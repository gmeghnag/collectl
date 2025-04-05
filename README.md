# ocp-collectl


### Run
- Label all the nodes, except the masters, as `collectl=true`: 
```
oc get node -o name -l node-role.kubernetes.io/master!= | xargs -I {}  oc label {} collectl=true 
```
Create the `DaemonSet` resource:
```
oc apply -k https://github.com/gmeghnag/ocp-collectl.git
```

