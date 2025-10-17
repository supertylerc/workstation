# workstation

For Arch, specifically Omarchy.  Assumes a from-scratch install.  Modify host config via [inventory/host_vars/localhost/main.yml](inventory/host_vars/localhost/main.yml)
as necessary.

## Setup

Install Ansible.  For this, recommend using `uv`.  Below are the commands, but they are also in [./bootstrap.sh](./bootstrap.sh),
so you could just run that script instead.

```bash
sudo pacman -S python-uv
uv tool install --force ansible --with-executables-from ansible-core,ansible-lint
```

## Running

Write your `become` password to `.become_password`.  This file is in the `.gitignore`.  Alternatively, add `-K` to the command
below to prompt for the password.

Then, just run as usual:

```bash
ansible-playbook local.yml
```

## Drift and Reconciliation

Systems can drift.  `workstation` helps mitigate this by creating a systemd service and timer to use `ansible-pull` to
stay in sync.  The timer runs according to `workstation_reconcile_timer` Ansible variable, which is `*:0/10:00`,
or every 10 minutes, by default.  This means that every 10 minutes, the entire playbook runs.

In order to leverage this feature, you either need passwordless `sudo` or you need to write your `sudo` password to
`workstation_become_password_file`, which is `$HOME/.become_password` by default.

## Security

Critically, this repository expects to be able to be run non-interactively.  Because it also requires elevated permissions,
this also means that your sudo password must be stored in a file somewhere.

Ansible supports obtaining this via an executable file.  If your `.become_password` is an executable file, then it will use
this file to obtain the password for elevating permissions.  For example, you could use `bitwarden-cli` to retrieve the password,
but then you must also have `bitwarden-cli` setup in such a way as to not require individual user password.

Given that this repository is intended to manage workstations, and not servers, the threat model is such that it is assumed that
if someone gains access to your workstation, you have much bigger problems than your sudo password being accessible in a non-interactive
manner.

## Adapting For You

You probably don't want the exact same packages that I use.  Really, this should be a collection and a set of
multiple roles, with a playbook that you could copy as an example, and then supply your own inventory.

However, I am very lazy, so I'm not following best practices here, because this is mostly for me.

If you also use Arch, then you can fork this repository and modify your variables as you see fit.
