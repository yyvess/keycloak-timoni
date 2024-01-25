package templates

import (
	netv1 "k8s.io/api/networking/v1"
)

#NetworkPolicy: netv1.#NetworkPolicy & {
	apiVersion: "networking.k8s.io/v1"
	kind:       "NetworkPolicy"
	#config:    #Config
	metadata:   #config.metadata
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
			if #config.ha {
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
						port:     #config.jgroups.port
					},
					]}
			},
		]
	}
}
