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

warning
-------

This method will install gVisor on selected nodes using a Daemonset. The associated pod execute a restart of containerd if needed which may affect other pods on the nodes.

Also, the containerd original `config.toml` file is overwritten with the one provided. This config is valid at the current time but may not take into account future parameters added by the Kapsule team. In any case, the config file now leverage `version = 2` to be able to use the `ConfigPath` option which is not the case for the original configuration.

gVisor will leverage systemd-cgroups using the experimental flag provided in `runsc.toml`
