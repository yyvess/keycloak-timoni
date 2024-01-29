// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

	replicas: 1

	virtualService: {
		gateways: [{"istio-system/istio-ingressgateway"}]
		hosts: [
			"keycloak.myorg.com",
		]
	}

	networkPolicyRules: [{
		from: [{
			namespaceSelector: {
				matchLabels: {
					"kubernetes.io/metadata.name": "istio-system"
				}
			}
			podSelector: {
				matchLabels: {
					app: "istio-ingressgateway"
				}
			}
		},
		]
		ports: [{
			protocol: "TCP"
			port:     8080
		},
		]},
	]

	admin: {
		password: {value: "admin"}
	}

	extraEnvs: [
		{name: "KC_PROXY", value:           "edge"},
		{name: "KC_HOSTNAME_STRICT", value: "false"},
		{name: "KC_LOG_LEVEL", value:       "DEBUG"},
	]
}
