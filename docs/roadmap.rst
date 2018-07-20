Roadmap
================================

# Plan to get to v0.1

- Load balancing configuration
- Redo everything's configuration now that DNS is fixed in k8s
- provision on demand, and give popup in meantime // https://getbootstrap.com/docs/4.0/components/modal/
- basic round robin load balancer for lab services. Just need a VIP to point to, and it does IP load balancing, not TCP

# Post-v0.1 Feature Roadmap

- GUI for putting together lab files

# Short Term Plan

1. End-to-end with guacamole, no preprovisioning, csrx.
2. Add in vmx but also no preprovisioning. Tell guacamole to wait for connectivity
3. Play with the idea of preprovisioning, or perhaps provisioning on faster instances.
