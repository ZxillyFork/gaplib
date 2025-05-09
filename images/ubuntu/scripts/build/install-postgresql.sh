#!/bin/bash -e
################################################################################
##  File:  install-postgresql.sh
##  Desc:  Install PostgreSQL
################################################################################
# Source the helpers
source $HELPER_SCRIPTS/os.sh
source $HELPER_SCRIPTS/install.sh

REPO_URL="https://apt.postgresql.org/pub/repos/apt/"

# Preparing repo for PostgreSQL
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgresql.gpg
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] $REPO_URL $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Fetch PostgreSQL version to install from the toolset
toolset_version=$(get_toolset_value '.postgresql.version')

# Install PostgreSQL
echo "Install PostgreSQL"
update_dpkgs
install_dpkgs postgresql-$toolset_version

echo "Install libpq-dev"
install_dpkgs libpq-dev

# Disable postgresql.service
systemctl is-active --quiet postgresql.service && systemctl stop postgresql.service
systemctl disable postgresql.service

rm /etc/apt/sources.list.d/pgdg.list
rm /usr/share/keyrings/postgresql.gpg

echo "postgresql $REPO_URL" >> $HELPER_SCRIPTS/apt-sources.txt
