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
		port:         *[if https {8443}, {8080}][0] | int & >0 & <=65535
	}

	// Pod exposed ports
	httpPort?: int & >0 & <=65535
	if (service.https) {
		httpsPort?: int & >0 & <=65535
	}

	// Pod optional settings.
	podAnnotations?: {[string]: string}
	podSecurityContext: corev1.#PodSecurityContext | *{
		fsGroup:             1000
		fsGroupChangePolicy: "OnRootMismatch"
	}
	imagePullSecrets?: [...timoniv1.ObjectReference]
	tolerations?: [...corev1.#Toleration]
	affinity?: corev1.#Affinity
	topologySpreadConstraints?: [...corev1.#TopologySpreadConstraint]

	// App settings.
	command: [...string] | *["/opt/keycloak/bin/kc.sh", "start"]

	extraEnvs: [...corev1.#EnvVar] | *[]

	serviceAccount: {
		enabled: *false | bool
	}

	// Issuer used to generate certificate & jks
	issuer: {
		enabled: *false | bool
		spec: issuerv1.#IssuerSpec | *{
			selfSigned: {}
		}
	}

	// Web certificate
	certificate: {
		enabled: *false | bool
		spec: certv1.#CertificateSpec & {
			dnsNames: *["localhost:\( service.port )"] | [...string]
			issuerRef: name: *"\(metadata.name)" | string
			secretName: "\(metadata.name)-cert"
		}
	}

	// Jks certificate for Jgroup
	jks: {
		enabled: *false | bool
		spec: certv1.#CertificateSpec & {
			commonName: *"infinispan-jks" | string
			issuerRef: name: *"\(metadata.name)" | string
			secretName: "\(metadata.name)-jks"
		}
	}

	pdb: {
		enabled: bool | *(replicas > 1)
		spec: policyv1.#PodDisruptionBudgetSpec & {
			minAvailable: *1 | int & >0 & <=65535
		}
	}

	networkPolicy: {
		enabled: *false | bool
		if networkPolicy.enabled {
			rules: [... netv1.#NetworkPolicyIngressRule]
		}
	}

	pvc: {
		enabled:          [if replicas > 1 {false}, bool | *false][0]
		storageClassName: *"standard" | string
		size:             *"1Gi" | string
	}

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
		type: [if replicas > 1 {
			"postgres" | "mariadb" | "mssql" | "mysql" | "oracle"
		},
			*"dev-file" | "dev-mem" | "postgres" | "mariadb" | "mssql" | "mysql" | "oracle",
		][0]
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
