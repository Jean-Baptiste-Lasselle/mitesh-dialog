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



export WHERE_TO_CREATE_RSA_KEY_PAIR=$1
export ROBOTS_ID=$2

function Usage () {
  echo " "
  echo "The [$0] script should be used with two mandatory arguments : "
  echo " [$0] \$FOLDER_WHERE_TO_CREATE_RSA_KEY_PAIR \$ROBOTS_ID"
  echo " "
  echo " Where : "
  echo "    FOLDER_WHERE_TO_CREATE_RSA_KEY_PAIR    is an existing folder path "
  echo "    ROBOTS_ID is the bumblebee id of an existing Robot"
  echo " "
  echo " Arguments You provided to [$0]: "
  echo " "
  echo "    FOLDER_WHERE_TO_CREATE_RSA_KEY_PAIR    WHERE_TO_CREATE_RSA_KEY_PAIR=[$WHERE_TO_CREATE_RSA_KEY_PAIR] "
  echo "    ROBOTS_ID                              ROBOTS_ID=[$ROBOTS_ID] "
  echo " "
  echo " Last, and required to run [$0], is that you have to set the [BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME] "
  echo " Environement Varaible, to the filename of the private key you want to generate"
  echo ""
}

if ! [ -d "$WHERE_TO_CREATE_RSA_KEY_PAIR" ]; then
  Usage && exit 1
fi;

if [ "x$WHERE_TO_CREATE_RSA_KEY_PAIR" == "x" ]; then
  Usage && exit 1
fi;

if [ "x$ROBOTS_ID" == "x" ]; then
  Usage && exit 1
fi;


if [ "x$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME" == "x" ]; then
  echo " [BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME] must be set"
  Usage && exit 1
fi;




export BUMBLEBEE_SSH_PUBLIC_KEY_FILENAME="${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}.pub"
export PRIVATE_KEY_FULLPATH=$WHERE_TO_CREATE_RSA_KEY_PAIR/${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}


export PEGASUS_DEFAULT_PRIVATE_KEY_PASSPHRASE="Etre ou ne pas etre, telle est la question"
# - putain mais ooui pour gitlab.com, la clef enregistrée ne DOIT PAS avoir de passphrase, sinon l'authentification foire !!!
# ou alors il faut tester comment faire la passphrase en mode command line silenceieux
export PEGASUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
# putain ouais c'est énorme j'ai bien testé que la [passphrase] fait échouer l'auth. [gitlab.com]
#
export LE_COMMENTAIRE_DE_CLEF="[$ROBOTS_ID]-bumblebee@[workstation]-$(hostname)"
export LE_COMMENTAIRE_DE_CLEF="[$ROBOTS_ID]-bumblebee@[$PIPELINE_EXECUTION_ID]"

ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $PRIVATE_KEY_FULLPATH -q -P "$PEGASUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"

ls -allh $WHERE_TO_CREATE_RSA_KEY_PAIR

sleep 3s
