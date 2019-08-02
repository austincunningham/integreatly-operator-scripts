#!/bin/bash

# oc login first
echo "Enter oc cluster url :"
read cluster
oc login $cluster -u opentlc-mgr -p r3dh4t1! 
# add a namespace
echo "Enter namespace :"
read namespace
#namespace=001-integreatly-operator

# Create the OperatorSource in OpenShift (https://raw.githubusercontent.com/integr8ly/manifests/master/operator-source.yml)
#oc create -f https://raw.githubusercontent.com/integr8ly/manifests/master/operator-source.yml
oc create -f ~/repo-integr8ly/integreatly-operator-scripts/operator-source.yml
# Create the Installation CustomResourceDefinition in OpenShift 
oc create -f ./deploy/crds/installation.crd.yaml
# Create the Namespace/Project for the Integreatly Operator to watch
oc new-project $namespace
# Create the Installation resource in the namespace we created
oc create -f ./deploy/crds/examples/installation.cr.yaml
# Create the Role, RoleBinding and ServiceAccount
oc create -f ./deploy/service_account.yaml
oc create -f ./deploy/role.yaml
oc create -f ./deploy/role_binding.yaml
# In the integr8ly/integreatly-operator directory, run the operator
operator-sdk up local --namespace=$namespace