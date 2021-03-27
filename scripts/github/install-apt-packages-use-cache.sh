#!/usr/bin/env bash

# Special script which supports installing apt-packages, caching installed files into a directory
# and then on next run if cache is available, re-using that cache

# Packages which will be installed and cached
# NOTE: shellcheck is already available in docker runner image we use
APT_PACKAGES="libldap2-dev libsasl2-dev libssl-dev libyaml-dev ldap-utils"

# Directory where installed package files will be copied - should match directory specified for
# cache target in github actions workflow
CACHE_DIRECTORY="${HOME}/apt_cache"

export APT_DIR="${CACHE_DIRECTORY}"
export APT_STATE_LISTS="${APT_DIR}/lists"
export APT_CACHE_ARCHIVES="${APT_DIR}/archives"

# shellcheck disable=SC2059
printf "dir::state::lists    ${APT_STATE_LISTS};\ndir::cache::archives    ${APT_CACHE_ARCHIVES};\n" | sudo tee /etc/apt/apt.conf

mkdir -p "${APT_STATE_LISTS}/partial"
mkdir -p "${APT_CACHE_ARCHIVES}/partial"

sudo apt-get -y update
# shellcheck disable=SC2086
sudo apt-get -f -y install ${APT_PACKAGES}
