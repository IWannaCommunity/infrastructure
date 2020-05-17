# Edits

Edits are documented here. These are changes made, usually to Kubernetes resources, that couldn't be done in Terraform for whatever reason.

---

## TITLE: HAProxy TCP Services ConfigMap

## BUG: Unfiled

## DESCRIPTION:
Terraform Helm Provider doesn't seem able to set arguments on pods that are created via Helm Chart.

## PATCH:
Manually apply `        - --tcp-services-configmap=default/haproxy-ingress-controller-tcp` to the `haproxy-ingress-controller` service under
```yml
spec:
  template:
    spec:
      containers:
      - args:
```

---

## TITLE: DigitalOcean Load Balancer Proxy Protocol

## BUG: Unfiled

## DESCRIPTION:
Load Balancer created from the HAProxy Ingress Helm Chart should have it's proxy protocol enabled, this in the future could be automated through clever usage of the DigitalOcean Terraform Provider.

## ACTION:
Manually enable `Proxy Protocol` on specified DigitalOcean Load Balancer.

---

## TITLE: HAProxy Ingress Controller Service Forwarded Ports

## BUG: Unfiled

## DESCRIPTION:
Even when the patch is applied for the HAProxy Ingress TCP Services ConfigMap, it doesn't seem to be able to forward it's own ports, even though it has the information to do so, this could just be a limitation of Kubernetes, and needs more investigation.

## WORKAROUND:
Apply this to the `haproxy-ingress-controller` service:
```yml
spec:
  clusterIP: 10.245.160.44
  externalTrafficPolicy: Local
  healthCheckNodePort: 30429
  ports:
  - name: jabber-c2s
    nodePort: 30213
    port: 5222
    protocol: TCP
    targetPort: 5222
  - name: jabber-c2s-tls
    nodePort: 32666
    port: 5223
    protocol: TCP
    targetPort: 5223
  - name: jabber-s2s
    nodePort: 32103
    port: 5269
    protocol: TCP
    targetPort: 5269
  - name: jabber-s2s-tls
    nodePort: 31676
    port: 5270
    protocol: TCP
    targetPort: 5270
  - name: jabber-http
    nodePort: 32174
    port: 5280
    protocol: TCP
    targetPort: 5280
  - name: quassel-tls
    nodePort: 32280
    port: 4242
    protocol: TCP
    targetPort: 4242
```

---

## TITLE: HAProxy Ingress Controller Deployment Forwarded Ports

## BUG: Unfiled

## DESCRIPTION:
Even when the patch is applied for the HAProxy Ingress TCP Services ConfigMap, it doesn't seem to be able to forward it's own ports, even though it has the information to do so, this could just be a limitation of Kubernetes, and needs more investigation.

## WORKAROUND:
Apply this to the `haproxy-ingress-controller` deployment:
```yml
spec:
  template:
    spec:
      containers:
        ports:
        - containerPort: 5222
          name: jabber-c2s
          protocol: TCP
        - containerPort: 5223
          name: jabber-c2s-tls
          protocol: TCP
        - containerPort: 5269
          name: jabber-s2s
          protocol: TCP
        - containerPort: 5270
          name: jabber-s2s-tls
          protocol: TCP
        - containerPort: 5280
          name: jabber-http
          protocol: TCP
        - containerPort: 4242
          name: quassel-tls
          protocol: TCP
```

---
