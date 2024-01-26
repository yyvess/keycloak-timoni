// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

	image: {
		repository: "quay.io/keycloak/keycloak"
		digest:     "sha256:cff31dc6fbb0ab0b66176b990e6b9e262fa74a501abb9a4bfa4a529cbc8a526a"
		tag:        "23.0"
	}

	ingress: {
		ingressClassName: "nginx"
		tls: [{
			hosts: ["fake"]
			secretName: "auth-tls-secret"
		},
		]
		rules: [{
			host: "auth.localtest.me"
			http: {
				paths: [{
					pathType: "Prefix"
					path:     "/"
					backend: {
						service: {
							name: "keycloak-web"
							port: {
								number: 8080
							}
						}}
				}]
			}}]
	}

	admin: {
		password: {value: "admin"}
	}

}
