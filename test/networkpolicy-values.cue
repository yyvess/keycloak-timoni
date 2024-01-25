@if(!debug)

package main

// Defaults
values: {
	envs: {
		KEYCLOAK_ADMIN_PASSWORD: "admin"
	}
	networkPolicyCreate: true
	networkPolicyRules: [{
		from: [{
			namespaceSelector: {
				matchLabels: {
					"project": "timoni"
				}
			}
		},
		]
		ports: [{
			protocol: "TCP"
			port:     8080
		},
		]
	},
	]
}
