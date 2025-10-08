#!/usr/bin/env bash

# Github Repository URL to Clone
GITHUB_REPO_CLONE=$1

# Working Directories
PROJECT_DIR=`pwd`
TMP=$PROJECT_DIR/tmp
REPO=$RANDOM

# Use GitHub as Upstream Final Destination
GITHUB_REPO=$2
# Use GitLab as Downstream and Begining of Pipeline
GITLAB_REPO=$3


if [ ! -d $TMP ]; then
  mkdir -p $TMP
fi

/usr/bin/git clone --bare $GITHUB_REPO_CLONE $TMP/$REPO
cd $TMP/$REPO
/usr/bin/git push --mirror $GITHUB_REPO
/usr/bin/git push --mirror $GITLAB_REPO

rm -rf $TMP/$REPO
