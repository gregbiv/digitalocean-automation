# PHP-Fpm+Nginx+Mysql on DigitalOcean with Ansible

Run an ansible playbook to create droplets on Digital Ocean, and then run
ansible to execute remote commands across groups of newly created machines.

# Purpose

This repository is mainly an exploration of Ansibles provisioning and
orchestration capabilities. It's tied to using the Digital Ocean cloud
provider just to make testing easier, but in principle could be extended
or altered to support other providers.

It allows you to define a set of droplets in a file, then use Ansible to
create those instances. Once created Ansible uses the Digital Ocean API
to discover the addresses and for you to run commands across portions of
your new infrastructure. Because Digital Ocean doesn't yet support any
sort of metadata on droplets the name is used to encode information. 

# Installation

After cloning this repository you need to install Ansible and a couple of
dependencies.

    pip install -r requirements.txt

You also need to set a couple of environment variables for the Digital
Ocean API. File is encrypted by Ansible Vault.

    ansible-vault edit group_vars/wp-blog/deployment_enc.yml

## Commands

`ansible-playbook -i ../live.ini wp-app.yml -u root`

## Contribute
Please, do contribute by [opening an issue](https://github.com/gregbiv/digitalocean-automation/issue) 
or creating a Pull Request.

## License
[MIT](https://github.com/gregbiv/digitalocean-automation/blob/master/LICENSE.md)
