@if(!debug)

package main

// Defaults
values: {
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

	admin: {
		password: {value: "admin"}
	}

}
