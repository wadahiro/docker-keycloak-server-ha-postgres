<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//*[local-name()='subsystem' and namespace-uri()='urn:jboss:domain:jgroups:4.0']/*[local-name()='channels' and namespace-uri()='urn:jboss:domain:jgroups:4.0']">
        <channels xmlns="urn:jboss:domain:jgroups:4.0" default="ee">
            <channel name="ee" stack="tcp"/>
        </channels>
    </xsl:template>

    <xsl:template match="//*[local-name()='subsystem' and namespace-uri()='urn:jboss:domain:jgroups:4.0']/*[local-name()='stacks' and namespace-uri()='urn:jboss:domain:jgroups:4.0']">
        <stacks xmlns="urn:jboss:domain:jgroups:4.0" default="tcp">
            <stack name="tcp">
                <transport type="TCP" socket-binding="jgroups-tcp">
                    <property name="external_addr">${env.EXTERNAL_HOST_IP}</property>
                </transport>

                <protocol type="JDBC_PING">
                    <property name="connection_driver">org.postgresql.Driver</property>
                    <property name="connection_url">jdbc:postgresql://${env.POSTGRES_PORT_5432_TCP_ADDR}:${env.POSTGRES_PORT_5432_TCP_PORT:5432}/${env.POSTGRES_DATABASE:keycloak}</property>
                    <property name="connection_username">${env.POSTGRES_USER:keycloak}</property>
                    <property name="connection_password">${env.POSTGRES_PASSWORD:password}</property>
                    <property name="initialize_sql">
                        CREATE TABLE IF NOT EXISTS jgroupsping (
                            own_addr VARCHAR(200) NOT NULL,
                            cluster_name VARCHAR(200) NOT NULL,
                            ping_data BYTEA DEFAULT NULL,
                            PRIMARY KEY (own_addr, cluster_name)
                        )
                    </property>
                </protocol>

                <protocol type="MERGE3"/>
                <protocol type="FD_SOCK" socket-binding="jgroups-tcp-fd">
                    <property name="external_addr">${env.EXTERNAL_HOST_IP}</property>
                </protocol>

                <protocol type="FD"/>
                <protocol type="VERIFY_SUSPECT"/>
                <protocol type="pbcast.NAKACK2"/>
                <protocol type="UNICAST3"/>
                <protocol type="pbcast.STABLE"/>
                <protocol type="pbcast.GMS"/>
                <protocol type="MFC"/>
                <protocol type="FRAG2"/>
            </stack>
        </stacks>
    </xsl:template>

    <xsl:template match="/*[local-name()='server' and namespace-uri()='urn:jboss:domain:4.0']/*[local-name()='socket-binding-group' and namespace-uri()='urn:jboss:domain:4.0']/*[local-name()='socket-binding' and namespace-uri()='urn:jboss:domain:4.0'][@name='jgroups-tcp']">
        <socket-binding xmlns="urn:jboss:domain:4.0" name="jgroups-tcp" interface="public" port="${{env.JGROUPS_TCP_PORT:7600}}"/>
    </xsl:template>

    <xsl:template match="/*[local-name()='server' and namespace-uri()='urn:jboss:domain:4.0']/*[local-name()='socket-binding-group' and namespace-uri()='urn:jboss:domain:4.0']/*[local-name()='socket-binding' and namespace-uri()='urn:jboss:domain:4.0'][@name='jgroups-tcp-fd']">
        <socket-binding xmlns="urn:jboss:domain:4.0" name="jgroups-tcp-fd" interface="public" port="${{env.JGROUPS_TCP_FD_PORT:17600}}"/>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

