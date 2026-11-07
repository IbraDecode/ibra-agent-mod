---
name: kubernetes-manifest-ops
description: Perancangan dan validasi manifest Kubernetes (Deployments, Services, Ingress, cert-manager SSL, HorizontalPodAutoscaler, dan NetworkPolicy).
version: 1.0.0
author: Ibra Ramdan
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [Kubernetes, K8s, DevOps, Cloud, Ingress, SSL, Scaling]
---

# Kubernetes Manifest Ops & Production Architecture (Ibra X 3.1)

Template manifest Kubernetes produksi yang mengedepankan ketersediaan tinggi (*High Availability*), rotasi SSL otomatis, dan isolasi jaringan (*Zero Trust Network Policy*).

## 1. Production Deployment & Service (`deployment.yaml`)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ibra-api
  namespace: default
  labels:
    app: ibra-api
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: ibra-api
  template:
    metadata:
      labels:
        app: ibra-api
    spec:
      containers:
        - name: app
          image: ghcr.io/ibradecode/api:latest
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8080
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 512Mi
          livenessProbe:
            httpGet:
              path: /healthz
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
          securityContext:
            readOnlyRootFilesystem: true
            runAsNonRoot: true
            runAsUser: 10001
---
apiVersion: v1
kind: Service
metadata:
  name: ibra-api-service
spec:
  type: ClusterIP
  selector:
    app: ibra-api
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

## 2. Ingress NGINX & Cert-Manager Auto SSL (`ingress.yaml`)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ibra-api-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/proxy-body-size: 20m
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
    - hosts:
        - api.ibra.ai.id
      secretName: ibra-api-tls
  rules:
    - host: api.ibra.ai.id
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ibra-api-service
                port:
                  number: 80
```

## 3. Horizontal Pod Autoscaler (HPA)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ibra-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ibra-api
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```
