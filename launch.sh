#!/bin/bash


export SECRETS_HOME=$(mktemp -d /tmp/pegasus.ide.XXXXXXXXXX)
echo ${SECRETS_HOME} > ide.secrets.vault
export TOPSECRET_FILE_NAME=gitservice.api.token

# ---- ---- ---- ---- ---- ---- ---- ---- ---- #
# ---- ---- ---- ---- ---- ---- ---- ---- ---- #
# INTERPOLATION
# ---- ---- ---- ---- ---- ---- ---- ---- ---- #
# ---- ---- ---- ---- ---- ---- ---- ---- ---- #
if [ -f ./.env ]; then
  echo "An existing $(pwd)/.env was found and saved to $(pwd)/.env.previous "
  echo "Beware : next time you run this script, $(pwd)/.env.previous will be deleted. "
  if [ -f ./.env.previous ]; then
    rm ./.env.previous
  fi;
  cp ./.env ./.env.previous
  rm ./.env
fi;
cp ./.template.env ./.env
# ---- ---- ---- ---- ---- ---- ---- ---- ---- #

# ----
# Contianer User UID GID mapping to host
# Setting linux user uid and gid inside container
sed -i "s#OPERATOR_UID_JINJA2_VAR#$(id -u)#g" ./.env
sed -i "s#OPERATOR_GID_JINJA2_VAR#$(id -g)#g" ./.env

# ----
# Setting secrets home outside container
sed -i "s#SECRETS_HOME_JINJA2_VAR#${SECRETS_HOME}#g" ./.env
sed -i "s#TOPSECRET_FILE_NAME_JINJA2_VAR#${TOPSECRET_FILE_NAME}#g" ./.env



docker system prune -f --all && docker-compose -f ./docker-compose.ide.yml down --rmi all && docker volume rm $(pwd|awk -F '/' '{print $NF}')_secrets


mkdir -p $(pwd)/secret-manager/

touch $(pwd)/secret-manager/gitservice.api.token

echo ""
echo "DEBUG POINT JBL "
docker-compose -f docker-compose.ide.yml up -d secret_manager && docker-compose -f docker-compose.ide.yml logs secret_manager

docker exec -it secretmanager bash

exit 0

docker-compose -f docker-compose.ide.yml build
docker-compose -f docker-compose.ide.yml up -d
docker logs -f secretmanager
exit 0
