#!/bin/bash




# echo "not implemented" && exit 1


# set -e

# BUMBLEBEE_HOME_INSIDE_CONTAINER/secrets/.ssh  is the secrets home...
mkdir -p $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh
chmod 700 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh

# - generating the key
chmod +x $BUMBLEBEE_HOME_INSIDE_CONTAINER/generer-paire-de-clefs-ssh-robot.sh
$BUMBLEBEE_HOME_INSIDE_CONTAINER/generer-paire-de-clefs-ssh-robot.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh ${BUMBLEBEE_LX_USERNAME}

# - registering the key to your Git service user account
sudo chmod +x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/gitlab-register-ssh.sh
${BUMBLEBEE_HOME_INSIDE_CONTAINER}/gitlab-register-ssh.sh

export BUMBLEBEE_SSH_PUBLIC_KEY_FILENAME="${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}.pub"
# chmod 644 /root/.ssh/id_rsa.pub
chmod 644 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PUBLIC_KEY_FILENAME
# chmod 600 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PUBLIC_KEY_FILENAME
# 644 is too open for public keys ?
# Sometimes I get weird messages stating this, from
# ssh servers
#

# chmod 600 /root/.ssh/id_rsa
chmod 600 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME

mkdir -p ~/.ssh


#
# Pegasus Robots Git settings  "Jean-Baptiste-lasselle"   / "jean.baptiste.lasselle.pegasus@gmail.com"
#
export GIT_USER_NAME=${GIT_USER_NAME:-'Jean-Baptiste-Lasselle'}
export GIT_USER_EMAIL=${GIT_USER_EMAIL:-'jean.baptiste.lasselle.pegasus@gmail.com'}
# what is going to be used to git config --global user.signingkey ${GIT_PGP_SIGNING_KEY}
export GIT_PGP_SIGNING_KEY=${GIT_PGP_SIGNING_KEY:-'7B19A8E1574C2883'}
# export GIT_GPG_SIGN
# export GIT_PGP_SIGNING_KEY

git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

if [ "x${GIT_GPG_SIGN}" == "x" ]; then
  echo "[GIT_GPG_SIGN] is not set, so [${BUMBLEBEE_LX_USERNAME}] will not sign commit for you, [${GIT_USER_NAME}]  "
else
  if [ "${GIT_GPG_SIGN}" == "true" ]; then

     echo "[GIT_GPG_SIGN] is set to 'true', so [${BUMBLEBEE_LX_USERNAME}] will sign commit for you, [${GIT_USER_NAME}]  "
     git config --global commit.gpgsign true
     git config --global user.signingkey 7B19A8E1574C2883
     echo "using PGP key [${GIT_PGP_SIGNING_KEY}] "
  fi;
fi;
echo "git user configuration completed"
# ----
# I do not need a signing key, bevcause it's just about
# cloning the ansible playbook, and running it, no way
# any git push
# ----


# ----
# Ssh client config
echo "PasswordAuthentication no" >> ~/.ssh/config
# ----


# ----
# SSH known hostnames
# Root user's default [known_hosts] file home folder
# ssh-keygen  -o PasswordAuthentication no
touch ~/.ssh/known_hosts
ssh-keygen -R $PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME
ssh-keyscan -H $PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME >> ~/.ssh/known_hosts
# Because maybe i will need Ansible to connect to [SOME_HOST_ON_AWS]
# ssh-keygen -R $SOME_HOST_ON_AWS
# ssh-keyscan -H $SOME_HOST_ON_AWS >> ~/.ssh/known_hosts
chmod 700 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh


echo " -------------------------------- "
echo " [$0] - [cat ~/.ssh/known_hosts] : "
echo " -------------------------------- "
cat ~/.ssh/known_hosts
echo " -------------------------------- "

# ----------------------------------------
# Je ne sais pas pourquoi, mais pour ce
# conteneur, il faut que la paire de
# clef publique / clef privée soit forcément au chemin [~/.ssh/id_rsa] [~/.ssh/id_rsa.pub]
# ----------------------------------------
mkdir -p ~/.ssh
cp $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PUBLIC_KEY_FILENAME ~/.ssh/id_rsa.pub
cp $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME ~/.ssh/id_rsa

# ----------------------------------------
chmod -R 700 ~/.ssh
chmod 644 ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id_rsa
# ----------------------------------------


chmod 700 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh

# chmod 644 /root/.ssh/id_rsa.pub
chmod 644 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PUBLIC_KEY_FILENAME
# chmod 600 /root/.ssh/id_rsa
chmod 600 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME


ssh -vTai $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh/$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME git@$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME

export GIT_SSH_COMMAND=$BUMBLEBEE_GIT_SSH_COMMAND


echo "BUMBLEBEE_GIT_SSH_COMMAND=[$BUMBLEBEE_GIT_SSH_COMMAND]"
echo "GIT_SSH_COMMAND=[$GIT_SSH_COMMAND]"

echo "End of Git initialisation, just BEFORE secret management tasks begin"

pwd
ls -allh $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER
