package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#Namespace: corev1.#Namespace & {
	#config: #Config
	apiVersion: "v1"
	kind:       "Namespace"
	metadata: {
		name:   #config.metadata.namespace
		if #config.virtualService != _|_ {
			labels: "istio-injection": "enabled"
		}
		if #config.metadata.annotations != _|_ {
			annotations: #config.metadata.annotations
		}
	}
}
