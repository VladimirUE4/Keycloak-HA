#!/bin/bash
minikube delete
minikube start
minikube addons enable ingress

# Attendre que l'Ingress Controller soit prêt
echo "Waiting for NGINX Ingress controller to be ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx

# Applique les fichiers de configuration de Keycloak
kubectl apply -f keycloak-deployment.yaml
kubectl apply -f keycloak-ingres.yaml
kubectl apply -f keycloak-service.yaml

# Attente que PostgreSQL soit prêt à accepter des connexions (utilisation de pg_isready)
echo "Waiting for PostgreSQL to be ready..."

# Boucle de vérification de PostgreSQL (en utilisant pg_isready)
until kubectl exec -it keycloak-db-0 -n default -- pg_isready -U postgres > /dev/null 2>&1; do
  echo "PostgreSQL not ready yet, retrying..."
  sleep 5
done

# Crée l'utilisateur et la base de données Keycloak
kubectl exec -it keycloak-db-0 -n default -- psql -U postgres -c "CREATE ROLE keycloak WITH LOGIN PASSWORD 'keycloak' CREATEDB CREATEROLE;"
kubectl exec -it keycloak-db-0 -n default -- psql -U postgres -c "CREATE DATABASE keycloak OWNER keycloak;"

# Confirmation
echo "Keycloak user and database created successfully!"
