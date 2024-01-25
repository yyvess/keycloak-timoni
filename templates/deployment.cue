package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	#config:         #Config
	#cmName:         string
	#certSecretName: string
	#jksSecretName:  string
	apiVersion:      "apps/v1"
	kind:            "Deployment"
	metadata:        #config.metadata
	spec: appsv1.#DeploymentSpec & {
		replicas: #config.replicas
		selector: matchLabels: #config.selector.labels
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
						env: [for k, v in #config.envs if v != _|_ && v.name == _|_ {
							name:  "\( k )"
							value: "\( v )"
						},
							for k, v in #config.envs if v != _|_ && v.name != _|_ {
								name: "\( k )"
								valueFrom:
									secretKeyRef: {
										name: "\( v.name )"
										key:  "\( v.key )"
									}}]
						ports: [
							{
								name:          "http"
								containerPort: *#config.envs.KC_HTTP_PORT | 8080
								protocol:      "TCP"
							},
							if #config.service.https {
								{
									name:          "https"
									containerPort: *#config.envs.KC_HTTPS_PORT | 8443
									protocol:      "TCP"
								}
							},
							if #config.ha {
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
							if #config.ha {
								{
									mountPath: "/opt/keycloak/conf"
									name:      "cache"
								}
							},
							if #certSecretName != _|_ {
								{
									mountPath: "/certs"
									name:      "certs"
								}
							},
							if #jksSecretName != _|_ {
								{
									mountPath: "/jks"
									name:      "jks"
								}
							},
						]
						resources:       #config.resources
						securityContext: #config.securityContext
					},
				]
				volumes: [
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
					if #config.ha {
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
