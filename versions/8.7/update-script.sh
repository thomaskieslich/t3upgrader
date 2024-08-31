#!/bin/bash

# set -ex

# Get base Settings
source "./t3upgrader/.env"

# get Version Settings
source ".env"

# 8.7
vendor/bin/typo3cms -nq install:generatepackagestates
vendor/bin/typo3cms -nq install:fixfolderstructure
vendor/bin/typo3cms -nq install:extensionsetupifpossible
vendor/bin/typo3cms -nq language:update

vendor/bin/typo3cms -nq database:import <${VERSIONS_DIR}/${CURRENT_CMS_VERSION}/"db-fixtures.sql"
vendor/bin/typo3cms -nq upgrade:all
vendor/bin/typo3cms -nq database:updateschema
vendor/bin/typo3cms -nq cache:flush
