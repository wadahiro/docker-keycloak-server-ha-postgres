#!/bin/bash

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi

export EXTERNAL_HOST_IP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)

exec /opt/jboss/keycloak/bin/standalone.sh -b $HOSTNAME -Djboss.node.name=$HOSTNAME -Djgroups.bind_addr=global $@
exit $?
