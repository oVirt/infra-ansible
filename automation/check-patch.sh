#!/bin/sh
# check-patch.sh - Automated tests for patches
#

# TODO: Add real tests here, this just checks the tools we need are installed
echo ============================ Ansible version ===========================
ansible --version
echo ========================= Ansible-lint version =========================
ansible-lint --version
echo ============================ flake8 version ============================
flake8 --version
