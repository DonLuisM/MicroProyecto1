#!/bin/bash 

echo "Agregando repositorio de Hashi Corp..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

echo "Actualizando paquetes..."
sudo apt update -y && sudo apt install -y consul nodejs npm

echo "Verificación de instalación de Consul y Node.js..."
consul -v
node -v
npm -v

# npm config set bin-links false

# echo "Instalando librerías necesarias en una carpeta fuera de la sincronizada..."
# mkdir -p /home/vagrant/app
# cp -r /home/vagrant/syncFold/* /home/vagrant/app/
# cd /home/vagrant/app
# npm install

echo "Iniciando agente de Consul..."
nohup consul agent -ui -node=node-two -bind=192.168.100.12 -client=0.0.0.0 -data-dir=. -enable-script-checks=true -retry-join=192.168.100.11 &
sleep 5

cd /home/vagrant/syncFold
rm -rf node_modules package-lock.json 
npm config set bin-links false
npm i express consul

sudo nohup node index_s2.js 3003 &
sudo nohup node index_s2.js 3004 &
sudo nohup node index_s2.js 3005 &


