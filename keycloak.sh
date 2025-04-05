#!/bin/bash
minikube delete
minikube start
minikube addons enable ingress

echo "Waiting for NGINX Ingress controller to be ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx

kubectl apply -f keycloak-deployment.yaml
kubectl apply -f keycloak-ingres.yaml
kubectl apply -f keycloak-service.yaml

echo "Waiting for PostgreSQL to be ready..."


until kubectl exec -it keycloak-db-0 -n default -- pg_isready -U postgres > /dev/null 2>&1; do
  echo "PostgreSQL not ready yet, retrying..."
  sleep 5
done

kubectl exec -it keycloak-db-0 -n default -- psql -U postgres -c "CREATE ROLE keycloak WITH LOGIN PASSWORD 'keycloak' CREATEDB CREATEROLE;"
kubectl exec -it keycloak-db-0 -n default -- psql -U postgres -c "CREATE DATABASE keycloak OWNER keycloak;"

echo "Keycloak user and database created successfully!"
