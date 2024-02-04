@if(!debug)

package main

// Defaults
values: {
	networkPolicy: {
		enabled: true
		rules: [{
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

	admin: {
		password: {value: "admin"}
	}

}
