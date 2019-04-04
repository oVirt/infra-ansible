#!/bin/bash
# check-patch.sh - Automated tests for patches
#

set -o nounset -o errexit -o pipefail -o xtrace

# check the tools's version, useful for debugging
echo ============================ Ansible version ===========================
ansible --version
echo ========================= Ansible-lint version =========================
ansible-lint --version
echo ============================ flake8 version ============================
pip install flake8
flake8 --version


echo ============================= flake8 check =============================
flake8 --exclude=plugins/strategy/mitogen_linear.py,$(find . -mindepth 2 -name ".git" -printf "%h,") --ignore=E126,E131,E501,E303 .

echo ========================== Ansible-lint check ==========================
ansible-lint -p --nocolor $(find . -mindepth 2 -name ".git" -printf "--exclude=%h ") playbooks/*.yml 

echo ======================== Ansible Galaxy install=========================
ansible-galaxy install -r requirements.yml

echo ========================= Ansible syntax check =========================
# until ANSIBLE_VAULT_PASSWORD_FILE support is added to Jenkins, delete Vault files (which are then not checked)
find . -name '*.vault.*' -delete
find playbooks/ -maxdepth 1 -name '*.yml' | xargs -n 1 ansible-playbook --syntax-check

# TODO: some actions cannot be checked properly with `ansible-playbook --check`
#       we should use `check_mode` when necessary but it is missing in many roles
#       also to do it properly we should test each each host installation in a discardable dedicated sub-container/VM

