#!/bin/bash


echo "starting pegasus hot ide"

sudo chmod +x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/hello.operator.user.sh
${BUMBLEBEE_HOME_INSIDE_CONTAINER}/hello.operator.user.sh

# echo "not implemented" && exit 1

echo "DEBUG JBL"
cat /bee/.topsecret/${TOPSECRET_FILE_NAME}

sudo chmod +x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/init-git.sh
${BUMBLEBEE_HOME_INSIDE_CONTAINER}/init-git.sh

git config --list

sleep infinity
exit 0
