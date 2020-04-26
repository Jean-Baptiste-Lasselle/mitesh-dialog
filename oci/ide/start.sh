#!/bin/bash

chown :${BUMBLEBEE_LX_GROUPNAME} -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
chmod a-rwx -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
chmod a+rw -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
chmod a+x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/*.sh

echo "starting pegasus hot ide"

sudo chmod +x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/hello.operator.user.sh
${BUMBLEBEE_HOME_INSIDE_CONTAINER}/hello.operator.user.sh

# echo "not implemented" && exit 1

echo "DEBUG JBL"
cat /bee/.topsecret/${TOPSECRET_FILE_NAME}


# BUMBLEBEE_HOME_INSIDE_CONTAINER/secrets/.ssh  is the secrets home...
mkdir -p $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh
chmod 700 $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets/.ssh

# -- initalizing gitops env.
sudo chmod +x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/init-git.sh
${BUMBLEBEE_HOME_INSIDE_CONTAINER}/init-git.sh

git config --list



sleep infinity
exit 0
