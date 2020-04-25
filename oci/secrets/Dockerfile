FROM debian

LABEL maintainer="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL author="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL build="0.0.0.0.0.0.0.0"
LABEL commitid="0.0.0.0.0.0.0.0"
LABEL daymood="firefox https://www.youtube.com/watch?v=fBM3nb-3iFs"

ARG BUMBLEBEE_HOME_INSIDE_CONTAINER=/bee
ENV BUMBLEBEE_HOME_INSIDE_CONTAINER=/bee


ARG OPERATOR_UID=${OPERATOR_UID}
ARG OPERATOR_GID=${OPERATOR_GID}

ARG BUMBLEBEE_LX_GROUPNAME=bumblebee
ARG BUMBLEBEE_LX_USERNAME=beeio
ARG BEE_GIT_SSH_COMMAND='ssh -i /bee/.secrets/.ssh/beeid_rsa'
ENV BEE_GIT_SSH_COMMAND=${BEE_GIT_SSH_COMMAND}
# ARG BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH="/bee/.secrets/.ssh/beeid_rsa"
ARG BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME="beeid_rsa"

ENV BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME=${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}

# ARG DEPENDENCY_LIST="git git-flow less curl openssh-server openssh-client tree dialog shadow sudo"
ARG DEPENDENCY_LIST="git git-flow less curl openssh-server openssh-client tree dialog sudo vim"
RUN getent --version

RUN apt-get update -y && apt-get install -y ${DEPENDENCY_LIST}

# -----
# CREATING FOLDERS
# -----
# Those two folders will have docker volumes mounted
# -----
# SSH keys will be in /bee/.secrets/.ssh
RUN mkdir -p /bee/.secrets
RUN mkdir -p /bee/.workspace
# ---
# The Secret Manager itself, has one secret. The "top" secret.
# Where the Gitlab API token will be expected, with
# file name 'gitservice.api.token' and full path /bee/.topsecret/gitservice.api.token
# ---
RUN mkdir -p /bee/.topsecret/

WORKDIR ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
# -----
# INSTALLING EXTERNAL FILES
# -----
COPY create-bee-user.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
# [init-git.sh] : executed at container runtime
COPY init-git.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
COPY start.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
RUN cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER} && ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/create-bee-user.sh
RUN chmod a+x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/*.sh


# -----
# CREATE BEE USER
# -----


VOLUME /bee/.workspace
VOLUME /bee/.secrets

USER ${BUMBLEBEE_LX_USERNAME}
USER root
WORKDIR /bee/.workspace

# CMD ["/bin/bash"]
CMD ["/bee/start.sh"]
