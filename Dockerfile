FROM jboss/keycloak-postgres:latest

RUN sed -ie 's@\(redirect-socket="https"\)@\1 proxy-address-forwarding="true"@' /opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
  
CMD ["-b", "0.0.0.0", "--server-config", "standalone-ha.xml"]
