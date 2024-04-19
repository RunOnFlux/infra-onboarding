#!/bin/bash

if [[ "$(id -u)" -ne 0 ]]; then
  echo 'This script must be run as root'
  exit 1
fi

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
