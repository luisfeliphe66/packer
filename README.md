 # Projeto Final - Gerenciamento de Configurações @ UFMT/2025

## Tecnologia Utilizada
**Packer** – [Documentação do Packer](https://developer.hashicorp.com/packer)

#### Tecnologias Aplicadas
- **Packer** (para automação da criação de imagens)   
- **Debian 12.9** – [Site do Debian](https://www.debian.org/)
- **QEMU** (virtualização) – [Site do QEMU](https://www.qemu.org/)
- **KVM** (aceleração de virtualização)
- Shell Scripting (para provisionamento pós-instalação)

## Integrantes
- Luis Feliphe Da Silva Batista
- César de Oliveira Júnior

---

## 1. Descrição da Tecnologia
O **Packer** é uma ferramenta de automação desenvolvida para criar imagens de máquinas virtuais de forma padronizada e sem intervenção manual. Com ele, é possível definir, através de arquivos de configuração (como o `pkr.hcl`), o ambiente que deve ser criado e provisionado. Essa tecnologia se integra a diversos provedores de virtualização, como o **QEMU** e o **KVM**, e utiliza scripts ( por exemplo, o `provision.sh`) para executar tarefas de configuração pós-instalação. Assim, o Packer auxilia na padronização dos ambientes, economizando tempo e minimizando erros comuns na configuração manual.

---

## 2. Descrição do Problema
Em ambientes de TI, a instalação e configuração manual de sistemas operacionais para múltiples servidores ou máquinas virtuais pode ser um processo demorado, sujeito a inconsistências e erros humanos.  
**Situação Hipotética:** 
Imagine uma equipe de TI que precisa implantar um ambiente com diversos servidores baseados no Debian 12.9 para testes de um novo software. Cada servidor precisa ser configurado de forma idéntica, garantindo que não haja variações que possam comprometer os testes. A configuração manual não só é trabalhosa, mas tambiém pode resultar em falhas que atrasam o projeto. Assim, é fundamental adotar uma solução automatizada que permita a criação de imagens de sistemas consistentes e replicáveis.

---

## 3. Solução
A solução proposta utiliza o **Packer** para automatizar a criação de uma imagem personalizada do Debian 12.9, combinando o plugin **QEMU** para virtualização e um arquivo `preseed.cfg` para realizar a instalação sem intervenção manual. A seguir, os passos implementados:

#### Passo 1: Prepariação do Ambiente
- **Instalação das Dependências:**  
```bash
sudo apt update && sudo apt install -y packer qemu-kvm
```

#### Passo 2: Configuração do Projeto
- **Arquivo de Configuração (`debian12.9.0.pkr.hcl`)**: Define as instruções para a criação da imagem, incluindo o uso do plugin QEMU e especificando o arquivo `preseed.cfg`.

- **Arquivo de Automatização (`preseed.cfg`)**: Automatiza a instalação do Debian 12.9, eliminando a necessidade de intervenção manual durante o processo.

- **Script de Provisionamento (`scripts/provision.sh`)**: Realiza configurações adicionais na máquina logo após a instalação.

#### Passo 3: Criação da Imagem
- Navegue até o diretório do projeto e execute o comando para iniciar a construção da imagem:

```bash
cd packer
packer build debian12.9.0.pkr.hcl
```

Após o término, a imagem no formato `.qcow2` será gerada no diretório `output-debian12.9.0/`.

#### Passo 4: Configuração e Execução da Máquina Virtual
- **Verificar a Imagem:** Confirme a existência do arquivo gerado:

```bash
ls output-debian12.9.0/
```
_Saída esperada:_
```
debian.qcow2
```

- **Iniciar a Máquina Virtual com QEMU:**

```bash
qemu-system-x86_64 \
    -enable-kvm \
    -m 2048 \
    -smp 2 \
    -drive file=output-debian12.9.0/debian.qcow2,format=qcow2 \
    -net nic -net user \
    -vga virtio \
    -display gtk
```

-  **Configuração Adicional (se necessário):** Caso a senha ou usuário não estejam definidos, acesse o modo de recuperação:
1. No menu GRUB, pressione `e` para editar.
2. Adicione `init=/bin/bash` ao final da linha do kernel.
3. Inicie com `Ctrl + X` ou `F10`.
4. Execute `passwd` para definir uma nova senha para o usuário root.

- **Acesso via SSH (Opcional):** Verifique o IP da máquina dentro da VM:

```bash
ip a
```

Em seguida, conecte-se:

```bash
ssh usuario@IP_DA_VM
```

- **Finalização da Máquina Virtual:** Para desligar a VM de forma adequada:

```bash
sudo shutdown -h now
```

Ou, se estiver utilizando o QEMU sem interface gráfica:

```bash
qemu-system-x86_64 -drive file=output-debian12.9.0/debian.qcow2,format=qcow2 -monitor stdio
(qemu) system_powerdown
```

---

## 4. Referências
- [Documentação do Packer](https://developer.hashicorp.com/packer)
- [Site do Debian](https://www.debian.org/)
- [Site do QEMU](https://www.qemu.org/)
- [Emojipedia (para ícones)](https://emojipedia.org/)
- [Vídeo demonstrando a instalação automatizada](https://youtu.be/Ez60E4zwGOQ)