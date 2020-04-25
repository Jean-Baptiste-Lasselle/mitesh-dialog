FROM debian


ARG BUMBLEBEE_HOME_INSIDE_CONTAINER=/bee

ARG OPERATOR_UID=${OPERATOR_UID}
ARG OPERATOR_GID=${OPERATOR_GID}

ARG BUMBLEBEE_LX_GROUPNAME=
ARG BUMBLEBEE_LX_USERNAME
ARG BEE_GIT_SSH_COMMAND='ssh -i /bee/.secrets/.ssh/beeid_rsa'
ENV BEE_GIT_SSH_COMMAND=${BEE_GIT_SSH_COMMAND}


ARG DEPENDENCY_LIST="git git-flow less curl openssh-server openssh-client tree"
RUN apt-get update -y && apt-get install -y ${DEPENDENCY_LIST}

# -----
# CREATING FOLDERS
# -----
# Those two folders will have docker volumes mounted
# -----
# SSH keys will be in /bee/.secrets/.ssh
RUN mkdir -p /bee/.secrets
RUN mkdir -p /bee/.workspace
# Where the Gitlab API token will be expected, with file name 'gitservice.api.token' and full path /bee/.topsecret/gitservice.api.token
RUN mkdir -p /bee/.topsecret/


# -----
# INSTALLING EXTERNAL FILES
# -----
COPY create-bee-user.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
# [init-git.sh] : executed at container runtime
COPY init-git.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}

# -----
# CREATE BEE USER
# -----


VOLUME /bee/.workspace
VOLUME /bee/.secrets

WORKDIR /bee/.workspace

CMD ["/bin/bash"]
