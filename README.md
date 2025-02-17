# Projeto Final - Gerenciamento de Configurações @ UFMT/2025 🚀

## Tecnologia Utilizada 🛠️
**Packer** – [Documentação do Packer](https://developer.hashicorp.com/packer)

#### Tecnologias Aplicadas
- **Packer** (para automação da criação de imagens)   
- **Debian 12.9** – [Site do Debian](https://www.debian.org/)
- **QEMU** (virtualização) – [Site do QEMU](https://www.qemu.org/)
- **KVM** (aceleração de virtualização)
- Shell Scripting (para provisionamento pós-instalação)

## Integrantes 👥
- Luis Feliphe Da Silva Batista
- César de Oliveira Júnior

---

## 1. Descrição da Tecnologia 💡
O **Packer** é uma ferramenta de automação desenvolvida para criar imagens de máquinas virtuais de forma padronizada e sem intervenção manual. Com ele, é possível definir, através de arquivos de configuração (como o `pkr.hcl`), o ambiente que deve ser criado e provisionado. Essa tecnologia se integra a diversos provedores de virtualização, como o **QEMU** e o **KVM**, e utiliza scripts (por exemplo, o `provision.sh`) para executar tarefas de configuração pós-instalação. Assim, o Packer auxilia na padronização dos ambientes, economizando tempo e minimizando erros comuns na configuração manual.

---

## 2. Descrição do Problema ⚠️
Em ambientes de TI, a instalação e configuração manual de sistemas operacionais para múltiplos servidores ou máquinas virtuais pode ser um processo demorado, sujeito a inconsistências e erros humanos.

**Cenário-Lab:**
Imagine uma equipe de TI que precisa implantar um ambiente com diversos servidores baseados no Debian 12.9 para testes de um novo software. Cada servidor precisa ser configurado de forma idêntica, garantindo que não haja variações que possam comprometer os testes. A configuração manual não só é trabalhosa, mas também pode resultar em falhas que atrasam o projeto (Infraestrutura imutável). Assim, é fundamental adotar uma solução automatizada que permita a criação de imagens de sistemas consistentes e replicáveis (Infraestrutura mutável).

---

## 3. Solução 🛠️
A solução proposta utiliza o **Packer** para automatizar a criação de uma imagem personalizada do Debian 12.9, combinando o plugin **QEMU** para virtualização e um arquivo `preseed.cfg` para realizar a instalação sem intervenção manual. A seguir, os passos implementados:

#### Passo 1: Preparação do Ambiente 🔧
- **Instalação das Dependências:**  
```bash
make dependency
```

#### Passo 2: Configuração do Projeto 🗂️
- **Arquivo de Configuração (`build.qemu.pkr.hcl`)**: Define as instruções para a criação da imagem, incluindo o uso do plugin QEMU e especificando o arquivo `preseed.cfg`.

- **Arquivo de Automatização (`preseed.cfg`)**: Automatiza a instalação do Debian 12.9, eliminando a necessidade de intervenção manual durante o processo.

- **Script de Provisionamento (`provision.sh`)**: Realiza configurações adicionais na máquina logo após a instalação.

#### Passo 3: Criação da Imagem 📦
- Navegue até o diretório do projeto e execute o comando para iniciar a construção da imagem:

```bash
cd packer
make build
```

Após o término, a imagem no formato `.qcow2` será gerada no diretório `build/debian/12.9/sem_swap/qemu/build_gerada/`.

#### Passo 4: Configuração e Execução da Máquina Virtual 💻
- **Verificar a Imagem:** Confirme a existência do arquivo gerado:

```bash
ls build/debian/12.9/sem_swap/qemu/build_gerada
```
_Saída esperada:_
```
debian-12.9.0-amd64-sem-swap.qcow2
```

---

## 4. Referências 📚
- [Documentação do Packer](https://developer.hashicorp.com/packer)
- [Site do Debian](https://www.debian.org/)
- [Site do QEMU](https://www.qemu.org/)
- [Emojipedia (para ícones)](https://emojipedia.org/)
- [Vídeo demonstrando a instalação automatizada](https://youtu.be/Ez60E4zwGOQ)