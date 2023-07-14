#!/bin/bash
# Runs OpenShift certification tool for all three PS+ chart variants
# Pre-requisites:
#     openShift deployment, accessible at OPENSHIFT_USER_VM
#     oc new-project test # must set a new default project
# Params: %1 is the version, e.g.: 3.3.1
# Once done, submit PR for each variant
OPENSHIFT_USER_VM=ec2-user@ec2-54-90-78-205.compute-1.amazonaws.com

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi
VERSION=$1

# git clone https://github.com/SolaceDev/openshift-helm-charts.git
# cd openshift-helm-charts
# # creates branch
# git checkout -b solace-$VERSION
# cd charts/partners/solace

mkdir .kube; scp -i "~/.ssh/cikey.pem" $OPENSHIFT_USER_VM:/home/ec2-user/.kube/config $PWD/.kube/
mkdir auth; scp -i "~/.ssh/cikey.pem" $OPENSHIFT_USER_VM:/home/ec2-user/auth/kubeconfig $PWD/auth/


for variant in '' '-dev' '-ha' ;
#for variant in '-ha' ;
  do
    echo == Creating dirs, fetching artifacts ==
    WORKDIR=pubsubplus-openshift"$variant"/$VERSION
    ARCHIVEVERSION=pubsubplus-openshift"$variant"-$VERSION.tgz
    mkdir -p $WORKDIR
    wget -O $WORKDIR/$ARCHIVEVERSION https://solaceproducts.github.io/pubsubplus-kubernetes-helm-quickstart/helm-charts-openshift/$ARCHIVEVERSION
    echo == Running certification ==
    podman run --rm -e KUBECONFIG=/auth/kubeconfig -v $PWD/.kube:/.kube -v $PWD/auth:/auth -v $(pwd):/charts   "quay.io/redhat-certification/chart-verifier" verify /charts/$WORKDIR/$ARCHIVEVERSION -S nameOverride=test > $WORKDIR/report.yaml
  done
