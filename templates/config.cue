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
		port: *[if https {8443}, {8080}][0] | int & >0 & <=65535
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

	extraEnvs: [...corev1.#EnvVar] | *[]

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
	// Requird to securize Jgroup
	jks: certv1.#CertificateSpec & {
		commonName: *"infinispan-jks" | string
		issuerRef: name: *"\(metadata.name)" | string
		secretName: "\(metadata.name)-jks"
	}

	// Issuer used to generate certificate & jks
	issuerCreate: *false | bool
	issuer:       issuerv1.#IssuerSpec

	pdbCreate: bool | *(replicas > 1)
	pdb: policyv1.#PodDisruptionBudgetSpec & {
		minAvailable: *1 | int & >0 & <=65535
	}

	networkPolicyCreate: *false | bool
	networkPolicyRules: [... netv1.#NetworkPolicyIngressRule]

	virtualService?: vsv1beta1.#VirtualServiceSpec

	ingress?: netv1.#IngressSpec

	admin: {
		user: *{value: *"admin" | string} | {valueFrom?: corev1.#EnvVarSource}
		password!: *{value?: string} | {valueFrom?: corev1.#EnvVarSource}
	}

	java: {
		options?: string
	}

	database: {
		[if replicas > 1 {
			type: {value: "postgres" | "mariadb" | "mssql" | "mysql" | "oracle"} & {valueFrom?: corev1.#EnvVarSource}
		}, {
			type?: *{value: *"dev-file" | "dev-mem" | "postgres" | "mariadb" | "mssql" | "mysql" | "oracle"} | {valueFrom?: corev1.#EnvVarSource}
		}][0]
		url?: *{value?: string} | corev1.#EnvVarSource
		username?: *{value?: string} | {valueFrom?: corev1.#EnvVarSource}
		password?: *{value?: string} | {valueFrom?: corev1.#EnvVarSource}
	}

	cache: {
		stack: *"kubernetes" | "tcp" | "udp" | "ec2" | "azure" | "google"
		jgroups: {
			name: *"jgroups" | string
		}
	}

}
