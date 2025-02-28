#!/bin/bash

# set -ex

# Get base Settings
source "./t3upgrader/.env"

# get Version Settings
source ${ROOT_ENV_FILE}

# 11.5

TYPO3_CLI_Command=vendor/bin/typo3

if vendor/bin/typo3 help install:fixfolderstructure > /dev/null 2>&1; then
  TYPO3_CLI_Command=vendor/bin/typo3
else
  TYPO3_CLI_Command=vendor/bin/typo3cms
fi

$TYPO3_CLI_Command -nq install:extensionsetupifpossible
$TYPO3_CLI_Command -nq language:update

$TYPO3_CLI_Command -nq database:import <${VERSIONS_DIR}/${CURRENT_CMS_VERSION}/"db-fixtures.sql"
$TYPO3_CLI_Command -nq upgrade:run
$TYPO3_CLI_Command -nq database:updateschema
$TYPO3_CLI_Command -nq cache:flush
$TYPO3_CLI_Command -nq referenceindex:update
$TYPO3_CLI_Command -nq cache:warmup
