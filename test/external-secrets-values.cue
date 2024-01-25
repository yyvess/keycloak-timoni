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

	envs: {
		KEYCLOAK_ADMIN: {
			name: "existing-secret"
			key:  "keycloak-admin-user"
		}
		KEYCLOAK_ADMIN_PASSWORD: {
			name: "existing-secret"
			key:  "keycloak-admin-password"
		}
	}
}
