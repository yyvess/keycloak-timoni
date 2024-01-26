// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

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
