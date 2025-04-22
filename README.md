# Execute `collectl` on RHOCP4

### Run
- Label all the nodes you want to monitor (here, for example, all the nodes, except the masters) as `collectl=true`: 
```
oc get node -o name -l node-role.kubernetes.io/master!= | xargs -I {}  oc label {} collectl=true 
```
Create the `Namespace/collectl`, `ClusterRoleBinding/collectl-privileged`, and `DaemonSet/collectl` resources:
```
oc apply -k https://github.com/gmeghnag/ocp-collectl.git
```

### Get collectl `war.gz` files locally:
```
mkdir -p collectl_out; oc get node -l collectl=true -o name -o json | jq '.items[].metadata.name' -r | while read NODE; do oc debug node/${NODE} -q --to-namespace=openshift-etcd -- chroot host sh -c 'cd /var/log/collectl; ls *.raw.gz' | while read FILE; do oc debug node/${NODE} -q --to-namespace=openshift-etcd -- chroot host sh -c "cd /var/log/collectl; cat $FILE" > collectl_out/${FILE}; done ; done
```
#### Extract the `.raw` files:
```
ls  collectl_out | while read GZ; do cat collectl_out/${GZ} | zcat > collectl_out/$(printf $GZ | egrep -o ".*.raw"); done
```
### Analyze the data:
```
podman run --rm -ti -v ${PWD}/collectl_out:/collectl_out quay.io/gmeghnag/collectl:4.3.20 sh
```

[1] https://collectl.sourceforge.net/Matrix.html
