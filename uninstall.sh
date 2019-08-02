#!/bin/sh 

PRODUCTS=("3scale" "amq-streams" "codeready-workspaces" "fuse" "launcher" "rhsso" )
NAMESPACE_PREFIX="integreatly"
OPERATOR_NAMESPACE="integreatly-operator"

# Remove Keycloak/Keycloak Realm CR
oc delete keycloak rhsso -n $NAMESPACE_PREFIX-rhsso
oc delete keycloakrealm openshift -n $NAMESPACE_PREFIX-rhsso

# Namespaces
oc delete project $OPERATOR_NAMESPACE
for i in ${PRODUCTS[*]}; do oc delete project $NAMESPACE_PREFIX-$i; done

# Remove CRDs
for i in $(oc get customresourcedefinitions | grep 3scale | awk '{print $1}'); do oc delete customresourcedefinition $i; done
for i in $(oc get customresourcedefinitions | grep kafka | awk '{print $1}'); do oc delete customresourcedefinition $i; done
oc delete customresourcedefinition checlusters.org.eclipse.che
oc delete customresourcedefinition installations.integreatly.org
oc delete customresourcedefinition launchers.launcher.fabric8.io
oc delete customresourcedefinition syndesises.syndesis.io
for i in $(oc get customresourcedefinitions | grep keycloak | awk '{print $1}'); do oc delete customresourcedefinition $i; done

# ClusterRoles
for i in $(oc get clusterroles | grep integreatly | awk '{print $1}'); do oc delete clusterrole $i; done

# Remove Operator Source
oc delete operatorsource integreatly-operators -n openshift-marketplace

# Remove Catalog Source Configs
for i in $(oc get catalogsourceconfigs -n openshift-marketplace | grep integreatly | awk '{print $1}'); do oc delete catalogsourceconfigs $i -n openshift-marketplace; done

