package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	#config:           #Config
	#highAvailability: bool
	#envs: [...corev1.#EnvVar]
	#cmName:         string
	#certSecretName: string
	#jksSecretName:  string
	apiVersion:      "apps/v1"
	kind:            "Deployment"
	metadata:        #config.metadata

	#javaOpts?: string
	if #highAvailability && #config.java.options == _|_ {
		#javaOpts: "-Djgroups.dns.query=\( #config.metadata.name )-\( #config.cache.jgroups.name )"
	}
	if #highAvailability && #config.java.options != _|_ {
		#javaOpts: "\( #config.java.options ) -Djgroups.dns.query=\( #config.metadata.name )-\( #config.cache.jgroups.name )"
	}
	if !#highAvailability && #config.java.options != _|_ {
		#javaOpts: #config.java.options
	}

	spec: appsv1.#DeploymentSpec & {
		replicas: #config.replicas
		selector: matchLabels: #config.selector.labels
		if #config.pvcCreate != _|_ {
			strategy: {
				type: "Recreate"
			}
		}
		template: {
			metadata: {
				labels: #config.selector.labels
				if #config.podAnnotations != _|_ {
					annotations: #config.podAnnotations
				}
			}
			spec: corev1.#PodSpec & {
				if #config.serviceAccountCreate {
					serviceAccountName: *#config.serviceAccount.metadata.name | #config.metadata.name
				}
				if !#config.serviceAccountCreate {
					serviceAccountName: *#config.serviceAccount.metadata.name | "default"
				}
				containers: [
					{
						name:            #config.metadata.name
						command:         #config.command
						image:           #config.image.reference
						imagePullPolicy: #config.image.pullPolicy
						env: [
							{name: "KC_HEALTH_ENABLED", value: "true"},
							{name: "KC_HTTP_ENABLED", value:   "true"},
							if #javaOpts != _|_ {
								{name: "JAVA_OPTS_APPEND", value: #javaOpts}
							}] +
							[if #highAvailability {
								[
									{name: "KC_CACHE", value:             "ispn"},
									{name: "KC_CACHE_STACK", value:       #config.cache.stack},
									{name: "KC_CACHE_CONFIG_FILE", value: "cache-ispn.xml"}]},
								[
									{name: "KC_CACHE", value: "local"}]][0] +
							[if #config.certificateCreate {
								[
									{name: "KC_HTTPS_CERTIFICATE_FILE", value:     "/certs/tls.crt"},
									{name: "KC_HTTPS_CERTIFICATE_KEY_FILE", value: "/certs/tls.key"}]},
								[]][0] +
							[if #config.database.type != _|_ {
								{name: "KC_DB", value: #config.database.type}
							}] +
							[if #config.httpPort != _|_ {
								{name: "KC_HTTP_PORT", value: "\(#config.httpPort)"}
							}] +
							[if #config.service.https && #config.httpsPort != _|_ {
								{name: "KC_HTTPS_PORT", value: "\(#config.httpsPort)"}
							}] +
							[for x in #envs {x}] +
							[for x in #config.extraEnvs {x}]

						ports: [
							{
								name:          "http"
								containerPort: *#config.httpPort | 8080
								protocol:      "TCP"
							},
							if #config.service.https {
								{
									name:          "https"
									containerPort: *#config.httpsPort | 8443
									protocol:      "TCP"
								}
							},
							if #highAvailability {
								{
									name:          "jgroups"
									containerPort: 7800
									protocol:      "TCP"
								}
							},
						]
						startupProbe: {
							httpGet: {
								path:   "/health"
								port:   "http"
								scheme: "HTTP"
							}
							initialDelaySeconds: 30
							failureThreshold:    30
							periodSeconds:       15
							httpGet: {
								path:   "/health"
								port:   "http"
								scheme: "HTTP"
							}
						}
						readinessProbe: {
							timeoutSeconds:   10
							periodSeconds:    15
							successThreshold: 1
							failureThreshold: 3
							httpGet: {
								path:   "/health"
								port:   "http"
								scheme: "HTTP"
							}
						}
						livenessProbe: {
							periodSeconds:    30
							timeoutSeconds:   10
							successThreshold: 1
							failureThreshold: 3
							httpGet: {
								path:   "/health"
								port:   "http"
								scheme: "HTTP"
							}
						}
						volumeMounts: [
								{
									name:      "tmp"
									mountPath: "/tmp"
								},
							if #highAvailability {
								{
									name:      "cache"
									mountPath: "/opt/keycloak/conf"
									readOnly:  true
								}
							},
							if #certSecretName != _|_ {
								{
									name:      "certs"
									mountPath: "/certs"
									readOnly:  true
								}
							},
							if #jksSecretName != _|_ {
								{
									name:      "jks"
									mountPath: "/jks"
									readOnly:  true
								}
							},
							if #config.pvcCreate {
								{
									name:      "data"
									mountPath: "/opt/keycloak/data/h2"
								}
							},
						]
						resources:       #config.resources
						securityContext: #config.securityContext
					},
				]
				volumes: [
					{
						name: "tmp"
						emptyDir: {
							sizeLimit: "128Mi"
						}
					},
					if #certSecretName != _|_ {
						{
							name: "certs"
							secret: {
								secretName: #certSecretName
							}
						}
					},
					if #jksSecretName != _|_ {
						{
							name: "jks"
							secret: {
								secretName: #jksSecretName
							}
						}
					},
					if #highAvailability {
						{
							name: "cache"
							configMap: {
								name: #cmName
								items: [{
									key:  "cache-ispn.xml"
									path: "cache-ispn.xml"
								}]
							}
						}
					},
					if #config.pvcCreate {
						{
							name: "data"
							persistentVolumeClaim: {
								claimName: #config.metadata.name
							}
						}
					},
				]
				if #config.podSecurityContext != _|_ {
					securityContext: #config.podSecurityContext
				}
				if #config.topologySpreadConstraints != _|_ {
					topologySpreadConstraints: #config.topologySpreadConstraints
				}
				if #config.affinity != _|_ {
					affinity: #config.affinity
				}
				if #config.tolerations != _|_ {
					tolerations: #config.tolerations
				}
				if #config.imagePullSecrets != _|_ {
					imagePullSecrets: #config.imagePullSecrets
				}
			}
		}
	}
}
