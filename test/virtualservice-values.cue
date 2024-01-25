// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

	replicas: 1

	image: {
		repository: "quay.io/keycloak/keycloak"
		digest:     "sha256:cff31dc6fbb0ab0b66176b990e6b9e262fa74a501abb9a4bfa4a529cbc8a526a"
		tag:        "23.0"
	}
	virtualService: {
		gateways: [{"istio-system/istio-ingressgateway"}]
		hosts: [
			"keycloak.dev.eu.zelros.com",
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

	envs: {
		KEYCLOAK_ADMIN_PASSWORD: "admin"
		KC_PROXY:                "edge"
		KC_HOSTNAME_STRICT:      false
		KC_LOG_LEVEL:            "DEBUG"
	}
}
