scaleway-kapsule-gvisor
=======================

To allow customers managing by themselves gVisor version and config on Kapsule, we don't provide anymore gVisor installed by default on Kapsule nodes.

This repository, inspired from this [method](https://github.com/neumanndaniel/kubernetes/tree/master/gvisor) allow adding back gVisor on specific nodes.

pre-requisite
-------------

Target nodes must be in Node pools with this specific tags `gvisor=enabled` and `taint=gvisor=enabled:NoSchedule` to be labeled and tainted correctly.

installation
------------

Run the Daemonset with the associated nodeSelector.

```
kubectl apply -f install.yaml
```

Create the RuntimeClass.

```
kubectl apply -f runtime.yaml
```

Run test

```
kubectl apply -f test.yaml
```

