#!/bin/bash


export SECRETS_HOME=$(mktemp -d /tmp/pegasus.ide.XXXXXXXXXX)
echo ${SECRETS_HOME} > ide.secrets.vault

# ---- ---- ---- ---- ---- ---- ---- ---- ---- #
# ---- ---- ---- ---- ---- ---- ---- ---- ---- #
# Contianer User UID GID mapping to host configuration
# ---- ---- ---- ---- ---- ---- ---- ---- ---- #
# ---- ---- ---- ---- ---- ---- ---- ---- ---- #

# Setting linux user uid and gid inside container
sed -i "s#OPERATOR_UID_JINJA2_VAR#$(id -u)#g" ./.env
sed -i "s#OPERATOR_GID_JINJA2_VAR#$(id -g)#g" ./.env
# Setting secrets home outside container
sed -i "s#SECRETS_HOME_JINJA2_VAR#${SECRETS_HOME}#g"


echo 'dummy value for the GitLab API Token' > $(pwd)/secret-manager/gitservice.api.token

docker-compose -f docker-compose.ide.yml build
docker-compose -f docker-compose.ide.yml up -d
