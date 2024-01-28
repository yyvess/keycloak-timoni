package templates

import (
	netv1 "k8s.io/api/networking/v1"
)

#NetworkPolicy: netv1.#NetworkPolicy & {
	apiVersion:        "networking.k8s.io/v1"
	kind:              "NetworkPolicy"
	metadata:          #config.metadata
	#config:           #Config
	#highAvailability: bool
	spec: netv1.#NetworkPolicySpec & {
		policyTypes: ["Ingress"]
		podSelector: {
			matchLabels: {
				#config.selector.labels
			}}
		ingress: [
			for v in #config.networkPolicyRules {
				v
			},
			// Allow all pod in the same namespance
			{
				from: [{
					podSelector: {}
				},
				]
				ports: [{
					protocol: "TCP"
					port:     #config.service.port
				},
				]},
			// Allow Keycloak Jgroup
			if #highAvailability {
				{
					from: [{
						podSelector: {
							matchLabels: {
								#config.selector.labels
							}
						}
					},
					]
					ports: [{
						protocol: "TCP"
						port:     7800
					}, {
						protocol: "TCP"
						port:     2157
					},
					]}
			},
		]
	}
}
