@if(!debug)

package main

// Defaults
values: {

	certificateCreate: true
	certificate: {
		issuerRef: {
			name: "existingIssuer"
		}
	}
	jksCreate: true
	jks: {
		issuerRef: {
			name: "existingIssuer"
		}
	}

	serviceAccount: {
		metadata: name: "existing-sa"
	}

	admin: {
		password: {value: "admin"}
	}
}
