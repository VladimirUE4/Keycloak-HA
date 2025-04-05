# 🛠️ Kubernetes Deployment: 2x Keycloak, Patroni PostgreSQL, Infinispan & Ingress

This repository provides an automated setup for deploying a production-ready stack on Kubernetes that includes:

- Two independent **Keycloak** instances  
- One **Patroni**-managed **PostgreSQL** cluster  
- One **Infinispan** instance for distributed caching  
- An **Ingress** resource to expose services externally  
- A **Shell script (`deploy.sh`)** to automate everything


---

## ✅ Prerequisites

- A running **Kubernetes cluster**
- `kubectl` configured and authenticated
- Sufficient cluster resources (RAM/CPU)
- Optional: Helm (if you're extending the setup)

---

## 🚀 How to Use

### 1. Clone the Repository

```bash
git clone https://github.com/VladimirUE4/Keycloak-HA.git
cd Keycloak-HA
```

### 2. Make the Script Executable

```bash
chmod +x keycloak.sh
```

### 3. Deploy Everything

```bash
./keycloak.sh
```

The script will apply all Kubernetes YAML files in the correct order and ensure all resources are created properly.

---

## 🔍 Verifying Deployment

Check that everything is running:

```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

Example test (replace domain with your Ingress host):

```bash
curl http://keycloak.example.com
```

---

## 🔧 Components Overview

### 🔐 Keycloak (x2)

Two separate instances of Keycloak, which can either be standalone or connected to the same PostgreSQL backend for HA scenarios.

### 🐘 PostgreSQL with Patroni

Highly available PostgreSQL cluster using Patroni, designed for automatic failover and replication.

### ⚡ Infinispan

Distributed in-memory cache. Can be used with Keycloak (for example, session caching) or other microservices.

### 🌐 Ingress

Ingress controller and rules to expose Keycloak and optionally Infinispan to external clients via HTTP(S).

---

## 🧹 Cleanup

To remove all deployed resources:

```bash
kubectl delete -f .
```

Or use the script (if it supports cleanup):

```bash
./deploy.sh clean
```

---

## 📝 Notes

- Be sure to update domains, secrets, and passwords in the YAMLs before deploying in production.
- Customize `ingress.yaml` to match your ingress class and TLS configuration.
- Add Persistent Volumes (PVCs) for PostgreSQL and Infinispan for data durability.

---

## 📬 Support

Feel free to open an issue or contact the maintainer if you need help or want to contribute.
