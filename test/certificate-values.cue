// Https with cert manager

@if(!debug)

package main

// Defaults
values: {

	replicas: 2
	image: {
		repository: "quay.io/keycloak/keycloak"
		digest:     "sha256:cff31dc6fbb0ab0b66176b990e6b9e262fa74a501abb9a4bfa4a529cbc8a526a"
		tag:        "23.0"
	}

	service: https: true

	issuerCreate:        true
	jksCreate:           true
	certificateCreate:   true
	networkPolicyCreate: true

	issuer: {
		selfSigned: {}
	}

	certificate: {
		duration:    "2160h0m0s"
		renewBefore: "360h0m0s"
		subject: organizations: ["zelros.com"]
		privateKey: {
			algorithm: "RSA"
			encoding:  "PKCS1"
			size:      4096
		}
	}

	admin: {
		password: {value: "admin"}
	}

	database: {
		type: {value: "postgres"}
		url: {value: "jdbc:postgresql://localhost/keycloak"}
		username: {value: "keycloak"}
		password: {
			valueFrom: {
				secretKeyRef: {
					name: "my-secret"
					key:  "my-key"
				}
			}
		}
	}

}
