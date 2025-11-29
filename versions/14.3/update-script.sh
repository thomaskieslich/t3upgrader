#!/bin/bash

# set -ex

# Get base Settings
source "./t3upgrader/.env"

# get Version Settings
source ${ROOT_ENV_FILE}

# 14.3
# Repair folder structure ((typo3-console))
#vendor/bin/typo3 -nq install:fixfolderstructure

# Initialize extensions (typo3-cli)
vendor/bin/typo3 -nq extension:setup

# (typo3-console)
#vendor/bin/typo3 -nq database:import <${VERSIONS_DIR}/${CURRENT_CMS_VERSION}/"db-fixtures.sql"

# (typo3-cli)
vendor/bin/typo3 -nq upgrade:run

# (typo3-console)
#vendor/bin/typo3 -nq database:updateschema

# (typo3-cli)
vendor/bin/typo3 -nq language:update

# (typo3-cli)
vendor/bin/typo3 -nq cache:flush

# (typo3-cli)
vendor/bin/typo3 -nq referenceindex:update

# (typo3-cli)
vendor/bin/typo3 -nq cache:warmup

# (typo3-cli)
vendor/bin/typo3 -nq fluid:cache:warmup

# (typo3-cli)
vendor/bin/typo3 -nq fluid:schema:generate
