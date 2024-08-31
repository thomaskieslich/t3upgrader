#!/bin/bash

set -ex

# Get base Settings
source "./t3upgrader/.env"

# get Version Settings
source ".env"

# 8.7
vendor/bin/typo3cms install:generatepackagestates
vendor/bin/typo3cms install:fixfolderstructure
vendor/bin/typo3cms install:extensionsetupifpossible
#  vendor/bin/typo3 lang:language:update

#  vendor/bin/typo3cms database:updateschema
#  vendor/bin/typo3cms upgrade:all
vendor/bin/typo3cms database:import <${VERSIONS_DIR}/${CURRENT_CMS_VERSION}/"db-fixtures.sql"
vendor/bin/typo3cms cache:flush
