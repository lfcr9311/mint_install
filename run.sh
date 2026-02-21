#!/usr/bin/env bash

set -e

echo "🔄 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y


echo "🧹 Limpando repositórios Docker antigos (evita erro apt-secure)..."
sudo rm -f /etc/apt/sources.list.d/docker.sources || true
sudo rm -f /etc/apt/sources.list.d/docker.list || true
sudo rm -f /etc/apt/keyrings/docker.asc || true


echo "📦 Pacotes base..."
sudo apt install -y \
  git curl wget unzip zip \
  build-essential \
  ca-certificates gnupg lsb-release \
  software-properties-common \
  gnome-terminal \
  python3 python3-pip python3-venv \
  flatpak


echo "☕ Java 21 LTS..."
sudo apt install -y openjdk-21-jdk


echo "🟢 Node LTS + Yarn..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
sudo corepack enable
sudo npm install -g yarn


echo "🐹 Go..."
sudo apt install -y golang-go


echo "🦀 Rust..."
if [ ! -d "$HOME/.cargo" ]; then
  curl https://sh.rustup.rs -sSf | sh -s -- -y
fi
source "$HOME/.cargo/env"


echo "🐘 PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql


echo "🐬 MySQL (MariaDB)..."
sudo apt install -y mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb


echo "🐳 Instalando Docker (repo oficial)..."
sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo chmod a+r /etc/apt/keyrings/docker.gpg

CODENAME=$(lsb_release -cs)

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $CODENAME stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y \
  docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker "$USER"
sudo systemctl enable docker


echo "🌐 Instalando ngrok..."
curl -fsSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | sudo gpg --dearmor -o /etc/apt/keyrings/ngrok.gpg

echo "deb [signed-by=/etc/apt/keyrings/ngrok.gpg] https://ngrok-agent.s3.amazonaws.com buster main" \
  | sudo tee /etc/apt/sources.list.d/ngrok.list > /dev/null

sudo apt update
sudo apt install -y ngrok


echo "📦 Flatpak + Flathub..."
if ! flatpak remotes | grep -q flathub; then
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi


echo "🧰 Apps dev..."
flatpak install -y flathub \
  com.visualstudio.code \
  io.beekeeperstudio.Studio \
  com.getpostman.Postman \
  org.wireshark.Wireshark \
  com.github.tchx84.Flatseal \
  org.telegram.desktop \
  com.discordapp.Discord


sudo apt autoremove -y


echo "======================================="
echo "✅ Ambiente backend completo pronto"
echo "Java:      $(java -version 2>&1 | head -n 1)"
echo "Node:      $(node -v)"
echo "Yarn:      $(yarn -v)"
echo "Go:        $(go version)"
echo "Rust:      $(rustc --version)"
echo "Python:    $(python3 --version)"
echo "Postgres:  $(psql --version)"
echo "MySQL:     $(mysql --version)"
echo "Docker:    $(docker -v)"
echo "ngrok:     $(ngrok version)"
echo "======================================="
echo "Reinicie a sessão para usar docker sem sudo"






flatpak install flathub com.sublimehq.SublimeText
flatpak install flathub io.beekeeperstudio.Studio
flatpak install flathub com.discordapp.Discord
flatpak install flathub org.gimp.GIMP
flatpak install flathub com.visualstudio.code
flatpak install flathub com.anydesk.Anydesk
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install flathub io.github.wiiznokes.fan-control
flatpak install flathub dev.zed.Zed
flatpak install flathub com.termius.Termius
