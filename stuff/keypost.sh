#!/usr/bin/env bash
ssh-keygen -o -a 256 -t ed25519 -C "$(hostname)-$(date +'%d-%m-%Y')"
curl -d '{"title":"'"$(hostname)-$(date +'%d-%m-%Y')"'","key":"'"$(cat ~/.ssh/id_ed25519.pub)"'"}'\
	-H 'Content-Type: application/json'\
	https://gitlab.com/api/v4/user/keys?private_token="$1"
