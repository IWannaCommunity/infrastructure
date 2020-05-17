# Resources

These are objects or resources, usually Kubernetes related, that could not be created inside or with Terraform or their providers, natively.

---
### Let's Encrypt (Staging) ClusterIssuer

This was a Kubernetes resource that resided on the Freeman Cluster.

```yml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # The ACME server URL
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: starz0r@starz0r.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-staging
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class:  haproxy
```

---

### Let's Encrypt (Production) ClusterIssuer

This was a Kubernetes resource that resided on the Freeman Cluster.

```yml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: starz0r@starz0r.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class:  haproxy
```

---

### Quassel (Staging) Certificate

This was a Kubernetes resource that resided on the Freeman Cluster.

```yml
apiVersion: cert-manager.io/v1alpha2
kind: Certificate
metadata:
  name: quassel-staging
  namespace: starz0r
spec:
  secretName: quassel-staging
  dnsNames:
  - quassel.starz0r.com
  issuerRef:
    name: letsencrypt-staging
    # We can reference ClusterIssuers by changing the kind here.
    # The default value is Issuer (i.e. a locally namespaced Issuer)
    kind: ClusterIssuer
    group: cert-manager.io
```

---
