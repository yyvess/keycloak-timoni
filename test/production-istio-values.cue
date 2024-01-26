// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

	replicas: 2

	virtualService: {
		gateways: [{"istio-system/istio-ingressgateway"}]
		hosts: [
			"keycloak.myorgs.com",
		]
	}

	networkPolicyCreate: true

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
		password: {value: "FIXME-USE-SECRET"}
	}
	database: {
		type: {value: "postgres"}
		url: {value: "jdbc:postgresql://keycloak.postgres.svc.cluster.local/keycloakdb?sslmode=require"}
		username: {
			valueFrom: {
				secretKeyRef: {
					name: "keycloakdb.credentials"
					key:  "username"
				}
			}
		}
		password: {
			valueFrom: {
				secretKeyRef: {
					name: "keycloakdb.credentials"
					key:  "password"
				}
			}
		}
	}
	extraEnvs: [
		{name: "KC_PROXY", value:           "edge"},
		{name: "KC_HOSTNAME_STRICT", value: "false"},
		{name: "KC_LOG_LEVEL", value:       "INFO"},
	]
}
