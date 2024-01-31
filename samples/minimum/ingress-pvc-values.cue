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

	pvcCreate: true
	pvc: {
		size:             "100M"
		storageClassName: "sc-kube-playground"
	}

	httpPort: 80
	service: port: 80

	resources: {
		limits: {
			cpu:    "1000m"
			memory: "768Mi"
		}
	}

	securityContext: {
		runAsUser:    0
		runAsGroup:   0
		runAsNonRoot: false
		capabilities:
		{
			add: ["NET_BIND_SERVICE"]
			drop: ["ALL"]
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
								number: 80
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
