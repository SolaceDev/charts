# openshift-helm-charts
This is a Solace fork of OpenShift Helm charts Repository, used to submit certified Helm charts.

Do not delete this branch!

This branch includes a helper script to prep the `pubsubplus-openshift`, `pubsubplus-openshift-dev` and `pubsubplus-openshift-ha` Helm charts for certification.

It requires OpenShift deployed and access.

Once prepared, separate PRs are required to submit the three charts.
Example:
-  [Added chart pubsubplus-openshift-ha-3.3.2 (#984)](https://github.com/openshift-helm-charts/charts/pull/984)
