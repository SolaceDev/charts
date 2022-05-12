#!/bin/bash
# Runs OpenShift certification tool for all three PS+ chart variants
# Pre-requisites: openShift deployment, with non-default project created
# scp -i "cikey.pem" ec2-user@ec2-3-88-216-95.compute-1.amazonaws.com:/home/ec2-user/.kube/config /cygdrive/c/Work/OpenShift/.kube/
# scp -i "cikey.pem" ec2-user@ec2-3-88-216-95.compute-1.amazonaws.com:/home/ec2-user/auth/kubeconfig /cygdrive/c/Work/OpenShift/auth/
#
# Params: %1 is the version
# Assumes "git clone https://github.com/SolaceDev/openshift-helm-charts.git" in place
# Must be run from the directory charts/partners/solace
# Once done, submit PR for each variant

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

#for variant in '' '-dev' '-ha' ;
for variant in '-ha' ;
  do
    echo == Creating dirs, fetching artifacts ==
    WORKDIR=pubsubplus-openshift"$variant"/$1
    ARCHIVENAME=pubsubplus-openshift"$variant"-$1.tgz
    mkdir -p $WORKDIR
    wget -O $WORKDIR/$ARCHIVENAME https://github.com/SolaceProducts/pubsubplus-kubernetes-quickstart/raw/gh-pages/helm-charts-openshift/$ARCHIVENAME
    echo == Running certification ==
    podman run --rm -e KUBECONFIG=/auth/kubeconfig -v /mnt/c/Work/OpenShift/.kube:/.kube -v /mnt/c/Work/OpenShift/auth:/auth -v $(pwd):/charts   "quay.io/redhat-certification/chart-verifier:1.6.0" -V 4.10.6 verify /charts/$WORKDIR/$ARCHIVENAME -S nameOverride=test > $WORKDIR/report.yaml
  done