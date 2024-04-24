#!/bin/bash

if [[ "$(id -u)" -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# 3>&2 2>&1 1>&3 swaps stdout / stderr

USER_CHOICE=$(
whiptail --title "Flux Infrastructure Onboarding" \
--menu "Choose the server type" 15 78 8 \
"Development" "This server is a dev server." \
"Test" "This server is a test server." \
"Production" "This server is a prod server." 3>&2 2>&1 1>&3
)

if [ $? -gt 0 ]; # Cancel pressed
    exit
fi

case $USER_CHOICE in
	"Development")
		server_type="dev"
	;;
	"Test")
		server_type="test"
	;;

	"Production")
		server_type="prod"
        ;;
esac

USER=ansible
ENDPOINT="https://raw.githubusercontent.com/RunOnFlux/infra-onboarding/master/deploy_pubkey_${server_type}"
PUBKEY=$(curl -s $ENDPOINT)

if getent passwd $USER > /dev/null 2>&1; then
  userdel $USER
  rm -rf /home/$USER
fi

useradd --create-home --system --shell /bin/bash --groups sudo $USER

echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

mkdir /home/$USER/.ssh

echo "${PUBKEY} ansible" > /home/$USER/.ssh/authorized_keys

chown $USER:$USER /home/$USER/.ssh/authorized_keys

echo "Server bootstrapped for Flux automation."
