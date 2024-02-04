package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
)

#ConfigMapIspn: timoniv1.#ImmutableConfig & {
	#config: #Config
	#Kind:   timoniv1.#ConfigMapKind
	#Meta:   #config.metadata
	#Data: {
		if #config.jks.enabled {
			"cache-ispn.xml": """
				  <infinispan
				          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				          xsi:schemaLocation="urn:infinispan:config:11.0 http://www.infinispan.org/schemas/infinispan-config-11.0.xsd"
				          xmlns="urn:infinispan:config:11.0">
				      <jgroups>
				          <!--
				          source: https://infinispan.org/docs/13.0.x/titles/embedding/embedding.html
				          -->
				          <stack name="encrypt-kubernetes" extends="kubernetes">
				              <SSL_KEY_EXCHANGE keystore_name="/jks/keystore.jks"
				                                      keystore_password="changeit"
				                                      port="2157"
				                                      port_range="0"
				                                      stack.combine="INSERT_AFTER"
				                                      stack.position="VERIFY_SUSPECT2"/>
				              <ASYM_ENCRYPT use_external_key_exchange="true"
				                            change_key_on_leave="false"
				                            change_key_on_coord_leave="false"
				                            sym_algorithm="AES"
				                            sym_keylength="128"
				                            asym_algorithm="RSA"
				                            asym_keylength="2048"
				                            stack.combine="INSERT_BEFORE"
				                            stack.position="pbcast.NAKACK2"/>
				          </stack>
				      </jgroups>

				      <cache-container name="keycloak">
				          <transport stack="encrypt-kubernetes" lock-timeout="60000"/>
				          <local-cache name="realms">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <memory max-count="10000"/>
				          </local-cache>
				          <local-cache name="users">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <memory max-count="10000"/>
				          </local-cache>
				          <distributed-cache name="sessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="authenticationSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="offlineSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="clientSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="offlineClientSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="loginFailures" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <local-cache name="authorization">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <memory max-count="10000"/>
				          </local-cache>
				          <replicated-cache name="work">
				              <expiration lifespan="-1"/>
				          </replicated-cache>
				          <local-cache name="keys">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <expiration max-idle="3600000"/>
				              <memory max-count="1000"/>
				          </local-cache>
				          <distributed-cache name="actionTokens" owners="2">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <expiration max-idle="-1" lifespan="-1" interval="300000"/>
				              <memory max-count="-1"/>
				          </distributed-cache>
				      </cache-container>
				  </infinispan>
				"""
		}
		if !#config.jks.enabled {
			"cache-ispn.xml": """
				  <!--
				    Unsecure configuration that not encrypt key exchange
				  -->
				  <infinispan
				          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				          xsi:schemaLocation="urn:infinispan:config:11.0 http://www.infinispan.org/schemas/infinispan-config-11.0.xsd"
				          xmlns="urn:infinispan:config:11.0">
				      <jgroups>
				          <!--
				          source: https://infinispan.org/docs/13.0.x/titles/embedding/embedding.html
				          -->
				          <stack name="encrypt-kubernetes" extends="kubernetes">
				              <ASYM_ENCRYPT use_external_key_exchange="false"
				                            change_key_on_leave="false"
				                            change_key_on_coord_leave="false"
				                            asym_keylength="2048"
				                            sym_keylength="128"
				                            sym_algorithm="AES"
				                            asym_algorithm="RSA"
				                            stack.combine="INSERT_BEFORE"
				                            stack.position="pbcast.NAKACK2"/>
				          </stack>
				      </jgroups>

				      <cache-container name="keycloak">
				          <transport stack="encrypt-kubernetes" lock-timeout="60000"/>
				          <local-cache name="realms">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <memory max-count="10000"/>
				          </local-cache>
				          <local-cache name="users">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <memory max-count="10000"/>
				          </local-cache>
				          <distributed-cache name="sessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="authenticationSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="offlineSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="clientSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="offlineClientSessions" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <distributed-cache name="loginFailures" owners="2">
				              <expiration lifespan="-1"/>
				          </distributed-cache>
				          <local-cache name="authorization">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <memory max-count="10000"/>
				          </local-cache>
				          <replicated-cache name="work">
				              <expiration lifespan="-1"/>
				          </replicated-cache>
				          <local-cache name="keys">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <expiration max-idle="3600000"/>
				              <memory max-count="1000"/>
				          </local-cache>
				          <distributed-cache name="actionTokens" owners="2">
				              <encoding>
				                  <key media-type="application/x-java-object"/>
				                  <value media-type="application/x-java-object"/>
				              </encoding>
				              <expiration max-idle="-1" lifespan="-1" interval="300000"/>
				              <memory max-count="-1"/>
				          </distributed-cache>
				      </cache-container>
				  </infinispan>
				"""
		}
	}
}
