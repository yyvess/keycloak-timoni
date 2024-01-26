// Custome Service account

@if(!debug)

package main

// Defaults
values: {

	replicas: 1

	serviceAccountCreate: true
	serviceAccount: {
		metadata: {
			name: "custom-sa"
			annotations: {"custom": "test"}}
	}
	admin: {
		password: {value: "admin"}
	}
}
