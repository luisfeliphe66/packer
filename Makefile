SHELL := /bin/bash
export

CMAKE := $(MAKE) --no-print-directory

PROJECT_DIR := $(CURDIR)

# all our targets are phony (no files to check).
.PHONY: help dependency deploy build check install-packer install-virtualbox install-vmware structure

help:
	@echo 'Get started: run the command "make deploy"'
	@echo ''
	@echo 'Usage: make [TARGET] [OPTIONS]'
	@echo ''
	@echo 'General targets:'
	@echo '  help                   Show this help text'
	@echo ''
	@echo 'Compounded targets:'
	@echo '  dependency             Install all projects dependencies.'
	@echo ''
	@echo '  deploy                 Prepare entire environment with all builds.'
	@echo ''
	@echo 'Application service targets:'
	@echo '  build                  Burn an OVF with given path.'
	@echo ''
	@echo '  check                  Check operation systems requirements.'
	@echo ''
	@echo '  install-packer         Install HashiCorp packer.'
	@echo ''
	@echo '  install-qemu           Install Qemu KVM.'

# Compounded service targets:
dependency:
	$(CMAKE) check
	$(CMAKE) install-packer
	$(CMAKE) install-qemu

deploy:
	$(CMAKE) dependency

# Selecione sem swap
sem_swap:
	$(CMAKE) build path=build/linux/debian/12.8/sem_swap/qemu PACKER_LOG=1

# Application service targets:
build:
	@echo "A imagem está sendo criada..."
	@packer build -force build/debian/12.9/sem_swap/qemu/build.qemu.pkr.hcl

check:
	@if ! cat /etc/os-release | grep -e '^NAME=.*Ubuntu.*' &> /dev/null; then echo "O seu Sistema Operacional precisa ser o Ubuntu!" && exit 1; fi;

install-packer:
	@if ! command -v packer &> /dev/null; then \
		curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
		&& sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $$(lsb_release -cs) main" \
		&& sudo apt update -y \
		&& sudo apt install -y packer; \
	fi;

install-qemu:
	@if ! command -v virt-manager &> /dev/null; then \
		sudo apt update -y \
		&& sudo apt install -y qemu-kvm virt-manager bridge-utils libvirt-daemon-system virtinst libvirt-clients; \
	fi;
	@sudo systemctl enable --now libvirtd
	@sudo systemctl start libvirtd
	@sudo usermod -aG kvm ${USER}
	@sudo usermod -aG libvirt ${USER}
