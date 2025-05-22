#!/bin/bash

NAMESPACE="myapp"

echo "[INFO] Iniciando o deploy da aplicação..."

# Inicia o Minikube, se necessário
if ! minikube status | grep -q "Running"; then
  echo "[INFO] Minikube não está rodando. Iniciando..."
  minikube start
fi

# Usa o Docker do Minikube
eval $(minikube docker-env)

# Build da imagem local
echo "[INFO] Construindo imagem Docker local..."
docker build -t myapp:latest .

# Criação do namespace
kubectl get ns $NAMESPACE >/dev/null 2>&1 || kubectl create ns $NAMESPACE

# Habilita o ingress do Minikube (caso necessário)
minikube addons enable ingress

# Deploy via Helm
echo "[INFO] Fazendo deploy via Helm..."
helm upgrade --install myapp ./helm/myapp -n $NAMESPACE

# Espera os pods ficarem prontos
echo "[INFO] Aguardando os pods ficarem prontos..."
kubectl wait --for=condition=ready pod -l app=myapp -n $NAMESPACE --timeout=90s

# Mostra URL de acesso
IP=$(minikube ip)
HOST="myapp.local"
echo "[INFO] Adicione ao seu /etc/hosts:"
echo "  $IP $HOST"
echo "[INFO] Acesse em: http://$HOST"

