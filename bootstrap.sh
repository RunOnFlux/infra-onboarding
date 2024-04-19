#!/bin/bash

USER=ansible

PUBKEY=$(curl -s https://raw.githubusercontent.com/RunOnFlux/infra-onboarding/master/deployment_pubkey)

[[ $(id -u) -eq 0 ]] || exec sudo /bin/bash -c "$(printf '%q ' "$BASH_SOURCE" "$@")"

useradd -m --system --shell /bin/bash --groups sudo $USER

echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

mkdir /home/$USER/.ssh

echo $PUBKEY > /home/$USER/.ssh/authorized_keys

chown $USER:$USER /home/$USER/.ssh/authorized_keys
