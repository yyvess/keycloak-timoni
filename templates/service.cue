package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#Service: corev1.#Service & {
	#config:    #Config
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		namespace: #config.metadata.namespace
		labels:    #config.metadata.labels
		if #config.service.annotations != _|_ {
			metadata: annotations: #config.service.annotations
		}
	}
	spec: corev1.#ServiceSpec & {
		type:     corev1.#ServiceTypeClusterIP
		selector: #config.selector.labels
	}
}

#ServiceHttp: #Service & {
	#config: #Config
	metadata: {
		name: #config.metadata.name
	}
	spec: {
		ports: [
			if !#config.service.https {
			{
				name:        "http"
				appProtocol: "http"
				port:        #config.service.port
				protocol:    "TCP"
				targetPort:  "http"
			},
			},
			if #config.service.https {
			{
				name:        "https"
				appProtocol: "https"
				port:        #config.service.port
				protocol:    "TCP"
				targetPort:  "https"
			}
			}
		]
	}
}

#ServiceJgroup: #Service & {
	#config: #Config
	metadata: {
		name: "\( #config.metadata.name )-\( #config.jgroups.name )"
	}
	spec: {
		ports: [
			{
				name:       "jgroups"
				port:       #config.jgroups.port
				protocol:   "TCP"
				targetPort: "jgroups"
			},
		]
	}
}
