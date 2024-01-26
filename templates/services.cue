package templates

import (
	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#Service: corev1.#Service & {
	apiVersion: "v1"
	kind:       "Service"
	#config:    #Config
	#component: string
	metadata: timoniv1.#MetaComponent & {
		#Meta:      #config.metadata
		#Component: #component
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
	#config:    #Config
	#component: "web"
	spec: {
		ports: [
			if !#config.service.https {
				{
					name:        "http"
					appProtocol: "http"
					port:        #config.service.port
					protocol:    "TCP"
					targetPort:  "http"
				}
			},
			if #config.service.https {
				{
					name:        "https"
					appProtocol: "https"
					port:        #config.service.port
					protocol:    "TCP"
					targetPort:  "https"
				}
			},
		]
	}
}

#ServiceJgroup: #Service & {
	#config:    #Config
	#component: "jgroups"
	spec: {
		clusterIP: "None"
		publishNotReadyAddresses: true
		ports: [
			{
				name:       "jgroups"
				port:       7800
				protocol:   "TCP"
				targetPort: "jgroups"
				appProtocol: "tcp"
			},
			{
				name:       "jgroups-ssl"
				port:       2157
				protocol:   "TCP"
				targetPort: "jgroups"
				appProtocol: "tcp"
			},
		]
	}
}
