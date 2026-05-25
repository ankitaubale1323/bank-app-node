
#!/bin/bash

set -e

echo "======================================"
echo "🚀 Updating system..."
echo "======================================"

sudo apt update -y

echo "======================================"
echo "📦 Installing dependencies..."
echo "======================================"

sudo apt install -y \
curl \
unzip \
docker.io

# ---------------- DOCKER ----------------

echo "======================================"
echo "🐳 Installing Docker..."
echo "======================================"

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker $USER

# Apply docker group without logout
newgrp docker <<EONG
docker --version
EONG

# ---------------- AWS CLI ----------------

echo "======================================"
echo "☁️ Installing AWS CLI..."
echo "======================================"

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"

unzip -o awscliv2.zip

sudo ./aws/install

# ---------------- kubectl ----------------

echo "======================================"
echo "☸️ Installing kubectl..."
echo "======================================"

curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

# ---------------- eksctl ----------------

echo "======================================"
echo "⚙️ Installing eksctl..."
echo "======================================"

curl --silent --location \
"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
| tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin

# ---------------- HELM ----------------

echo "======================================"
echo "📦 Installing Helm..."
echo "======================================"

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ---------------- ARGOCD CLI ----------------

echo "======================================"
echo "🚀 Installing ArgoCD CLI..."
echo "======================================"

curl -sSL -o argocd \
https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

chmod +x argocd

sudo mv argocd /usr/local/bin/

# ---------------- SONARQUBE ----------------

echo "======================================"
echo "🔍 Starting SonarQube..."
echo "======================================"

docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  sonarqube:community

# ---------------- VERIFY ----------------

echo "======================================"
echo "✅ Verifying installations..."
echo "======================================"

docker --version
aws --version
kubectl version --client
eksctl version
helm version
argocd version --client

echo ""
echo "======================================"
echo "🎉 INSTALLATION COMPLETED"
echo "======================================"

echo ""
echo "SonarQube URL:"
echo "http://<EC2-PUBLIC-IP>:9000"

echo ""
echo "SonarQube Default Credentials:"
echo "Username: admin"
echo "Password: admin"

echo ""
echo "Configure AWS:"
echo "aws configure"

