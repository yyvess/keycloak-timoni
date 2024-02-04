// Https with cert manager

@if(!debug)

package main

// Defaults
values: {

	replicas: 2

	service: https: true

	jks: enabled:           true
	networkPolicy: enabled: true

	issuer: {
		enabled: true
		spec: {
			selfSigned: {}
		}
	}

	certificate: {
		enabled: true
		spec: {
			duration:    "2160h0m0s"
			renewBefore: "360h0m0s"
			subject: organizations: ["myorg.com"]
			privateKey: {
				algorithm: "RSA"
				encoding:  "PKCS1"
				size:      4096
			}
		}
	}

	admin: {
		password: {value: "admin"}
	}

	database: {
		type: "postgres"
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
