#!/bin/bash
set -ex

# This is the CI server script to deploy the sidekiq worker
#
# The working directory should be the git root
#
# The caller should have the following environment variables set:
#
# USERNAME: cloudfoundry username
# PASSWORD: cloudfoundry password
# SPACE: the space to which you want to deploy

[[ -v SPACE ]] || read -p "Which space? (int,staging,live): " SPACE

./infrastructure/scripts/install-cf.sh

cf login -a api.cloud.service.gov.uk -u $USERNAME -p $PASSWORD -o "beis-mspsds" -s $SPACE

cf push -f sidekiq-manifest.yml

cf logout