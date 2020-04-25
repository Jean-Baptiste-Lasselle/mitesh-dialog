#!/bin/bash


export SECRETS_HOME=$(mktemp -d /tmp/pegasus.ide.XXXXXXXXXX)
echo ${SECRETS_HOME} > ide.secrets.vault

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



docker system prune -f --all && docker-compose -f ./docker-compose.ide.yml down --rmi all && docker volume rm $(pwd|awk -F '/' '{print $NF}')_secrets


mkdir -p $(pwd)/secret-manager/

touch $(pwd)/secret-manager/gitservice.api.token

echo ""
echo "DEBUG POINT JBL "
docker-compose -f docker-compose.ide.yml up -d secret_manager
exit 0

docker-compose -f docker-compose.ide.yml build
docker-compose -f docker-compose.ide.yml up -d
docker logs -f secretmanager
exit 0
