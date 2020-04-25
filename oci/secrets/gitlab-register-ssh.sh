#!/bin/bash


echo " "
echo " ------------------------------------------------------------------------------------ "
echo "This script generates an RSA SSH KeyPair for your ide bot"
echo " ------------------------------------------------------------------------------------ "
echo "Then it regsiters that key to your gitlab/github user, using the Gitlab / Github API token you provided at [CCCC] "
echo " ------------------------------------------------------------------------------------ "
echo " "



#
# Le but de ce script, est de remplacer la logique des robots qui sera implémentée plus tard.
#
# Après ce script, on aura la paire de clefs disponible dans le répertoire spécicifié en entréé
#


export PRIVATE_KEY_FULLPATH=
export BUMBLEBEE_SSH_PUBLIC_KEY_FILENAME="${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}.pub"
export PRIVATE_KEY_FULLPATH=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.ssh/${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}
export PUBLIC_KEY_FULLPATH="${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.ssh/${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}.pub"


ls -allh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.ssh

sleep 3s




# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  AJOUT DE LA CLEF SSH AUX CLEFS SSH
# $$$$$$$$$$  DU COMPTE UTILISATEUR ROBOT SUR GITLAB.COM
# $$$$$$$$$$  SE FAIT AVEC L'USAGE DE
# $$$$$$$$$$  l'ACCESS TOKEN [GITLAB API v4]
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

# export QUESTION="Connect to your gitlab [$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME] account, \n In the Settings Menu for your gitlab [$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME] user, Search for the \"Personal Access Token\" Menu, \n from which you will be able to create a new token for your pegasus. What's the valueof yoru token? \n (Copy / paste the token value and press Enter Key) "

#
# Pas de valeur par défaut,le [2>] estlà pour faire la redirection de canal de sortie du processs (synchrone) de la commande [dialog]
#
# dialog --inputbox "$QUESTION" 15 50 2> ./gitlab.access.token.reponses.pegasus


# export PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=gitlab.com
# export GITLAB_ACCESS_TOKEN=$(cat ./gitlab.access.token.reponses.pegasus)

if ! [ -f /bee/.topsecret/${TOPSECRET_FILE_NAME} ]; then
  echo "Bee ${PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME} API TOKEN  Top secret was not found where expected at [/bee/.topsecret/${TOPSECRET_FILE_NAME}]"
  echo "Bee needs tohat token to work for you"
  exit 7
fi;

export GITLAB_ACCESS_TOKEN=$(/bee/.topsecret/${TOPSECRET_FILE_NAME})

# Security (don't leave any secret on the file system, ne it in a container or a VM):
rm ./gitlab.access.token.reponses.pegasus

export ACCESS_TOKEN=$GITLAB_ACCESS_TOKEN

# export ACCESS_TOKEN=qPb4xYwfiExRu-uGk9Bv

echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Liste des clefs SSH avant ajout de la clef pegasus : "
ls -allh $WHERE_TO_CREATE_RSA_KEY_PAIR

curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .


# -- Now Adding Pegasus SSH Key to the User, using the TOKEN
# export THAS_THE_PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
export THAS_THE_PUB_KEY=$(cat "$PRIVATE_KEY_FULLPATH".pub )

echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Ajout de la clef SSH avant ajout de la clef pegasus : "
export PAYLOAD="{ \"title\": \"clef_SSH_PEGASUS${RANDOM}\", \"key\": \"$THAS_THE_PUB_KEY\" }"
curl -H "Content-Type: application/json" -H "PRIVATE-TOKEN: $ACCESS_TOKEN" -X POST --data "$PAYLOAD" "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .



echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Liste des clefs SSH APRES ajout de la clef pegasus : "
curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .
