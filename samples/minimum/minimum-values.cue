//
// Keycloak deployment minimum requirdement
//
// ! Not for prodution usage, Keycloak configuration is store on an empty directory
//

@if(!debug)

package main

// Defaults
values: {

	admin: {
		password: {value: "admin"}
	}

}
