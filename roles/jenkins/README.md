# Ansible Playbook: Jenkins and Plugins Installation

## Introduction:

This ansible role will help to setup jenkins on a machine from scratch below are the tasks that we can perform with this role:

    1. This includes installing the packages(httpd,firewalld,java,jenkins)

    2. Setting up the vhost and network

    3. Creating an admin user with full access as 'ansible_admin'

    4. This user will be used for installing or upgrading version plugins to the jenkins

    5. Apart from this we can use this role for upgrading and downgrading the jenkins version

## Variables:

Following are the varibles used and there defination:

hosts.yml

    ### jenkins_masters: DNS-server name


playbooks/jenkins_main.yml

    ### jenkins_version: Variable for providing version for jenkins provided in host_vars e.g. jenkins_version: jenkins-2.249.4


host_vars/jenkins-staging.ovirt.org/plugins_list.yml

    ### jenkins_plugin_var: variable for plugin list, this varible holds the list of plugins hash fromat which has the name of plugin mapping to the version to be installed.
    The Plugins upgrading can be performed by simply updating the version in the list. Also the complete list for plugins can be obtained by the groovy script explained in next section.
    The list will be as shown below:

        jenkins_plugin_var:
      - { name: 'Parameterized-Remote-Trigger', version: '3.1.5.1' }
      - { name: 'ace-editor', version: '1.1' }
      - { name: 'analysis-core', version: '1.96' }
      - { name: 'analysis-model-api', version: '9.6.0' }
      :::
      :

roles/jenkins/tasks/plugins.yml

    ### plugin_result : registering result from the plugin installation task

## Pre-requisites:

Before running the role we need to ensure that we have below prequisites setup on our machine:

    List of plugins that are requied to be updated in plugins_list.yml under host_vars for specfic jenkins instance
    Or use below groovy script to get the list of plugins that is requied from any existing jenkins instance

    ```
    def pluginList = new ArrayList(Jenkins.instance.pluginManager.plugins)
        pluginList.sort { it.getShortName() }.each{
        plugin ->
        println ("- { name: '${plugin.getShortName()}', version: '${plugin.getVersion()}' }")
        }
    ```


## Running the playbook:

Jenkins Version:
 To install a specific version for jenkins, provide the version in hosts.yml under host_vars for required jenkins instance
    e.g. : jenkins_version: jenkins-2.249.3


    The playbook can run using ansible-playbook command, e.g.


    ```
        ansible-playbook --limit host_var_name --ssh-extra-args="-o StrictHostKeyChecking=no -i ~/path/to/private-key" playbooks/jenkins_main.yml
    ```


To update only the plugins, use:

```
    ansible-playbook -t jenkins_plugins playbooks/jenkins_main.yml
```

To update jenkins version or setup only, use:

```
    ansible-playbook -t jenkins_server playbooks/jenkins_main.yml
```

or to run both jenkins and plugin installation:

```
    ansible-playbook -t jenkins playbooks/jenkins_main.yml
```

(or without a tag)

## SSL Configuration:

To use Letsencrypt, add below lines to "host_vars/FQDN/web.yml"

```
use_tls: True
use_letsencrypt: True
force_tls: True
```

To use custom certificates:

```
use_tls: True
force_tls: True
```

Add below files in /infra-ansible/playbooks/web/jenkins for adding or updating SSL cert.

```
src: "web/jenkins/{{ inventory_hostname }}.ca.crt"
src: "web/jenkins/{{ inventory_hostname }}.crt"
src: "web/jenkins/{{ inventory_hostname }}.key"
```

