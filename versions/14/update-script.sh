#!/bin/bash

# set -ex

# Get base Settings
source "./t3upgrader/.env"

# get Version Settings
source ${ROOT_ENV_FILE}

# 14.*
vendor/bin/typo3 -nq extension:setup
vendor/bin/typo3 -nq language:update

#vendor/bin/typo3 -nq database:import <${VERSIONS_DIR}/${CURRENT_CMS_VERSION}/"db-fixtures.sql"
vendor/bin/typo3 -nq upgrade:run
vendor/bin/typo3 -nq cache:flush
vendor/bin/typo3 -nq referenceindex:update
vendor/bin/typo3 -nq cache:warmup
vendor/bin/typo3 -nq fluid:cache:warmup

vendor/bin/typo3 -nq fluid:schema:generate
