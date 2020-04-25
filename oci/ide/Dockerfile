FROM debian




ARG DEPENDENCY_LIST="git git-flow less curl openssh-server openssh-client tree"
RUN apt-get update -y && apt-get install -y ${DEPENDENCY_LIST}

ARG BEE_GIT_SSH_COMMAND='ssh -i /bee/.secrets/.ssh/beeid_rsa'
ENV BEE_GIT_SSH_COMMAND=${BEE_GIT_SSH_COMMAND}

RUN mkdir -p /bee/.secrets/.ssh
RUN mkdir -p /bee/.workspace
VOLUME /bee/.workspace
VOLUME /bee/.secrets
