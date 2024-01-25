package templates

import (
	netv1 "k8s.io/api/networking/v1"
)

#Ingress: netv1.#Ingress & {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	#config:    #Config
	metadata: {
		name:      #config.metadata.name
		namespace: #config.metadata.namespace
		labels:    #config.metadata.labels
		if #config.metadata.annotations != _|_ {
			annotations: (#config & #config.ingress).metadata.annotations
		}
	}
	spec: #config.ingress
}
