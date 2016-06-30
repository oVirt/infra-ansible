
oVirt Infrastructure Management using Ansible

Currently it is using Foreman+Puppet, so this is a first shot at
preparing a future migration. The migration to Mailman 3 on
mail.phx.ovirt.org is used as a working example.

You can use 'group_vars/all/local_settings.yml' for you local
settings like ansible_become_pass if your computer storage is
encrypted. Use --ask-sudo-pass if you don't want to use this
method. Currently Ansible is unable to ask _when needed_ so
the global setting as been disabled in 'ansible.cfg'.

