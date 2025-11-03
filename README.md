# workstation

Ansible configuration for managing a Linux workstation. Currently supports:
- **Arch Linux** (specifically Omarchy, but should work with standard Arch)
- **Fedora Linux**

Assumes a from-scratch install. Modify host config via [inventory/host_vars/localhost/main.yml](inventory/host_vars/localhost/main.yml)
as necessary.

## Setup

Install Ansible. For this, recommend using `uv`. The bootstrap script ([./bootstrap.sh](./bootstrap.sh))
handles distribution-specific installation automatically:

**Arch Linux:**
```bash
./bootstrap.sh
# Or manually:
sudo pacman -S python-uv
uv tool install --force ansible --with-executables-from ansible-core,ansible-lint
```

**Fedora:**
```bash
./bootstrap.sh
# Or manually:
sudo dnf install -y python3-pip
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"
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

## Config Files

This repository does not currently perform configuration.  It is expected that you have a separate dotfiles repository
and management solution.  For me, that is GNU stow.

If you find yourself needing secrets in environment variables, then the pattern that I leverage with GNU stow is to use
a password manager's CLI to read the secret and load it into the varaible.  This introduces some delays when spawning a
new shell, so you may want to separate this out into a file that does not get read when spawning a shell and is instead
a manual action to source when necessary.

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

If you use Arch or Fedora, you can fork this repository and modify your variables as you see fit.

## Distribution-Specific Notes

### Package Differences

Some packages are distribution-specific:
- **Arch Linux**: Uses AUR packages like `cursor-bin`, `claude-code`, `python-uv` from official repos
- **Fedora**: Some packages like `cursor-bin` and `claude-code` may not be available in default repos and may require manual installation or alternative sources (e.g., Flatpak)

### Package Lists

The playbook uses separate package lists for each distribution:
- `general_packages_arch`: Packages for Arch Linux
- `general_packages_fedora`: Packages for Fedora

Modify these in `inventory/host_vars/localhost/main.yml` to customize your package selection.

### Bash Configuration

- **Arch (Omarchy)**: Automatically sources Omarchy's default bash configuration
- **Fedora**: Uses standard bash configuration without Omarchy-specific settings
