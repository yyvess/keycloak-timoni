package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
	corev1 "k8s.io/api/core/v1"
	certv1 "cert-manager.io/certificate/v1"
	issuerv1 "cert-manager.io/issuer/v1"
	policyv1 "k8s.io/api/policy/v1"
	netv1 "k8s.io/api/networking/v1"
	vsv1beta1 "networking.istio.io/virtualservice/v1beta1"
)

#secretReference: {
	name: string
	key:  string
}

// Config defines the schema and defaults for the Instance values.
#Config: {
	// The kubeVersion is a required field, set at apply-time
	// via timoni.cue by querying the user's Kubernetes API.
	kubeVersion!: string
	// Using the kubeVersion you can enforce a minimum Kubernetes minor version.
	// By default, the minimum Kubernetes version is set to 1.20.
	clusterVersion: timoniv1.#SemVer & {#Version: kubeVersion, #Minimum: "1.20.0"}

	// The moduleVersion is set from the user-supplied module version.
	// This field is used for the `app.kubernetes.io/version` label.
	moduleVersion!: string

	// The Kubernetes metadata common to all resources.
	// The `metadata.name` and `metadata.namespace` fields are
	// set from the user-supplied instance name and namespace.
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}

	// The labels allows adding `metadata.labels` to all resources.
	// The `app.kubernetes.io/name` and `app.kubernetes.io/version` labels
	// are automatically generated and can't be overwritten.
	metadata: labels: timoniv1.#Labels

	// The annotations allows adding `metadata.annotations` to all resources.
	metadata: annotations?: timoniv1.#Annotations

	// The selector allows adding label selectors to Deployments and Services.
	// The `app.kubernetes.io/name` label selector is automatically generated
	// from the instance name and can't be overwritten.
	selector: timoniv1.#Selector & {#Name: metadata.name}

	// The image allows setting the container image repository,
	// tag, digest and pull policy.
	// The default image repository and tag is set in `values.cue`.
	image!: timoniv1.#Image

	// The resources allows setting the container resource requirements.
	// By default, the container requests 10m CPU and 32Mi memory.
	resources: timoniv1.#ResourceRequirements | *{
		requests: {
			cpu:    *"200m" | timoniv1.#CPUQuantity
			memory: *"768Mi" | timoniv1.#MemoryQuantity
		}
	}

	// The number of pods replicas.
	// By default, the number of replicas is 1.
	replicas: *1 | int & >0

	// The securityContext allows setting the container security context.
	// By default, the container is denined privilege escalation.

	securityContext: corev1.#SecurityContext | *{
		allowPrivilegeEscalation: *false | true
		capabilities:
		{
			drop: *["ALL"] | [string]
		}
		privileged:             *false | true
		readOnlyRootFilesystem: *false | true
		runAsNonRoot:           false | *true
		seccompProfile: {
			type: "RuntimeDefault"
		}
	}

	// The service allows setting the Kubernetes Service annotations and port.
	// By default, the HTTP port is 8080.
	service: {
		annotations?: timoniv1.#Annotations
		https:        true | *false
		if https {
			port: *8443 | int & >0 & <=65535
		}
		if !https {
			port: *8080 | int & >0 & <=65535
		}
	}

	// Pod optional settings.
	podAnnotations?: {[string]: string}
	podSecurityContext?: corev1.#PodSecurityContext
	imagePullSecrets?: [...timoniv1.ObjectReference]
	tolerations?: [...corev1.#Toleration]
	affinity?: corev1.#Affinity
	topologySpreadConstraints?: [...corev1.#TopologySpreadConstraint]

	// App settings.
	command: [...string] | *["/opt/keycloak/bin/kc.sh", "start"]

	ha: replicas > 1

	serviceAccountCreate: *false | bool
	serviceAccount:       corev1.#ServiceAccount

	certificateCreate: *false | bool
	// Web certificate
	certificate: certv1.#CertificateSpec & {
		dnsNames: *["localhost:\( service.port )"] | [...string]
		issuerRef: name: *"\(metadata.name)" | string
		secretName: "\(metadata.name)-cert"
	}

	jksCreate: *false | bool
	// Requird to securize Jgroup in HA
	jks: certv1.#CertificateSpec & {
		commonName: *"infinispan-jks" | string
		issuerRef: name: *"\(metadata.name)" | string
		secretName: "\(metadata.name)-jks"
	}

	// Issuer used to generate certificate & jks
	issuerCreate: *false | bool
	issuer:       issuerv1.#IssuerSpec

	pdbCreate: bool | *ha
	pdb: policyv1.#PodDisruptionBudgetSpec & {
		minAvailable: *1 | int & >0 & <=65535
	}

	networkPolicyCreate: *false | bool
	networkPolicyRules: [... netv1.#NetworkPolicyIngressRule]

	virtualService?: vsv1beta1.#VirtualServiceSpec

	ingress?: netv1.#IngressSpec


	fileDb: false | *(envs.KC_DB == "dev-file" | envs.KC_DB == _|_)

	jgroups: {
		name: *"jgroups" | string
		port: *7800 | int & >0 & <=65535
	}

	envs: {
		if !ha {
			KC_DB?:            "dev-mem" | "dev-file" | "postgres" | "mariadb" | "mssql" | "mysql" | "oracle"
			KC_CACHE:          "local"
			JAVA_OPTS_APPEND?: string
		}
		if ha {
			KC_DB!:               "postgres" | "mariadb" | "mssql" | "mysql" | "oracle"
			KC_CACHE:             "ispn"
			KC_CACHE_CONFIG_FILE: "cache-ispn.xml"
			JAVA_OPTS_APPEND:     *"-Djgroups.dns.query=\( metadata.name )-\( jgroups.name )" | string
		}
		KC_HEALTH_ENABLED:               true
		KC_HTTP_ENABLED:                 *true | false
		KC_HTTP_PORT?:                   int & >0 & <=65535
		KC_HTTPS_PORT?:                  int & >0 & <=65535
		KC_HOSTNAME_PORT?:               int & >0 & <=65535
		KC_HOSTNAME?:                    string
		KC_HOSTNAME_ADMIN?:              string
		KC_HOSTNAME_URL?:                string
		KC_HOSTNAME_ADMIN_URL?:          string
		KC_HOSTNAME_PATH?:               string
		KC_HOSTNAME_STRICT?:             true | false
		KC_HOSTNAME_STRICT_HTTPS?:       true | false
		KC_HOSTNAME_STRICT_BACKCHANNEL?: true | false
		KC_PROXY?:                       "none" | "edge" | "reencrypt" | "passthrough"
		KC_METRICS_ENABLED?:             true | false
		KEYCLOAK_ADMIN:                  *"admin" | string | #secretReference
		KEYCLOAK_ADMIN_PASSWORD:         string | #secretReference
		KC_DB_URL?:                      string | #secretReference
		KC_DB_USERNAME?:                 string | #secretReference
		KC_DB_PASSWORD?:                 string | #secretReference
		KC_CACHE_STACK:                  *"kubernetes" | "tcp" | "udp" | "ec2" | "azure" | "google"
		KC_LOG_LEVEL?:                   string
		KC_LOG_CONSOLE_OUTPUT?:          string
		KC_LOG_CONSOLE_FORMAT?:          string
		if certificateCreate {
			KC_HTTPS_CERTIFICATE_FILE:     *"/certs/tls.crt" | string
			KC_HTTPS_CERTIFICATE_KEY_FILE: *"/certs/tls.key" | string
		}
		if !certificateCreate {
			KC_HTTPS_CERTIFICATE_FILE?:     string
			KC_HTTPS_CERTIFICATE_KEY_FILE?: string
		}
	}
}
