#!/bin/bash
# Script de provisionamento pós-instalação para Debian 12.9
# Instala pacotes essenciais e configurações de segurança

# Atualiza a lista de pacotes
echo "📦 Atualizando pacotes..."
apt update -y && apt upgrade -y

# Instala pacotes essenciais
echo "⚙️ Instalando pacotes básicos..."
apt install -y curl wget vim git ufw fail2ban htop net-tools nano rsync cmatrix

# Configura firewall UFW
echo "🛡️ Configurando firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw enable

# Configura Fail2Ban
echo "🚨 Configurando Fail2Ban..."
cat <<EOL > /etc/fail2ban/jail.local
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3
EOL
systemctl restart fail2ban

# Limpeza final
echo "🧹 Limpando pacotes desnecessários..."
apt autoremove -y && apt autoclean -y

# Finalização
echo "✅ Configuração concluída!"
