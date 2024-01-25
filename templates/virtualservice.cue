package templates

import (
	vsv1beta1 "networking.istio.io/virtualservice/v1beta1"
)

#VirtualService: vsv1beta1.#VirtualService & {
	#config:  #Config
	metadata: #config.metadata
	spec: #config.virtualService & {
		http: [
			{
				match: [{
					uri: {
						prefix: "/health"
					}}, {
					uri: {
						prefix: "/metrics"
					}},
				]
				directResponse: {
					status: 403
				}
			},
			{
				match: [{
					uri: {
						prefix: *"/" | #config.envs.KC_HOSTNAME_PATH
					}},
				]
				route: [{
					destination: {
						host: "\( #config.metadata.name )-web"
						port: {
							number: #config.service.port
						}
					}}]
			}]
	}
}
