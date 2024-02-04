// Custome Service account

@if(!debug)

package main

// Defaults
values: {

	replicas: 1

	serviceAccount: {
		enabled: true
	}
	admin: {
		password: {value: "admin"}
	}
}
