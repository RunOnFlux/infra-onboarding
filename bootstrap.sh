#!/bin/bash

[[ $(id -u) -eq 0 ]] || exec sudo /bin/bash -c "$(printf '%q ' "$BASH_SOURCE" "$@")"

USER=ansible

PUBKEY=$(curl -s https://raw.githubusercontent.com/RunOnFlux/infra-onboarding/master/deployment_pubkey)

if getent passwd $USER > /dev/null 2>&1; then
  userdel $USER
  rm -rf /home/$USER
fi

useradd --create-home --system --shell /bin/bash --groups sudo $USER

echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

mkdir /home/$USER/.ssh

echo "${PUBKEY} ansible" > /home/$USER/.ssh/authorized_keys

chown $USER:$USER /home/$USER/.ssh/authorized_keys
