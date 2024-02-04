@if(!debug)

package main

// Defaults
values: {

	certificate: {
		enabled: true
		spec: {
			issuerRef: {
				name: "existingIssuer"
			}
		}
	}

	jks: {
		enabled: true
		spec: {
			issuerRef: {
				name: "existingIssuer"
			}
		}
	}

	serviceAccount: {
		enabled: true
	}

	admin: {
		password: {value: "admin"}
	}
}
