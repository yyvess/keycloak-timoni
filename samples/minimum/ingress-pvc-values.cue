//
// Keycloak deployment minimum requirdement
//
// ! Not for prodution usage, Keycloak configuration is store on an empty directory
//

@if(!debug)

package main

// Defaults
values: {

	#hostname: "keycloak.kube-playground.tolron.fr"

	pvc: {
		enabled: true
		size:             "100M"
		storageClassName: "sc-kube-playground"
	}

	resources: {
		limits: {
			cpu:    "1000m"
			memory: "768Mi"
		}
	}

	ingress: {
		ingressClassName: "ing-kube-playground"
		tls: [{
			hosts: [#hostname]
			secretName: "cert-kubeplayground"
		},
		]
		rules: [{
			host: #hostname
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

	extraEnvs: [
		{name: "KC_HOSTNAME_STRICT", value: "false"},
		{name: "KC_PROXY", value:    "edge"},
	]

}
