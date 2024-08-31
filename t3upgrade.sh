#!/bin/bash

# set -x
set -e

# Get base Constants
if [ -f ${BASH_SOURCE%/*}/.env ]; then
  source "${BASH_SOURCE%/*}/.env"
fi

# get Version Settings
source ".env"

CMS_TYPE=${CMS_TYPE}
VERSIONS=(${CMS_VERSIONS})

# Get last version to upgrade to
LAST_VERSION=${VERSIONS[@]: -1}

# Create Directories
mkdir -p ${DB_BACKUP_DIR}
mkdir -p ${LOG_DIR}

# Loop through versions and upgrade step by step
for version in "${VERSIONS[@]}"; do

  echo "Create DB Backup Dir"
  mkdir -p ${DB_BACKUP_DIR}/${version}

  echo "Checkout ${version} branch ..."
  git checkout ${CMS_TYPE}-${version}

  if [ "${version}" = "${BASE_CMS_VERSION}" ]; then
    echo "Copy Production DB"
    rm -rf ${LOG_DIR}/*
    cp ${BASE_DB} ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz
  else
    echo "Export current DB ..."
    ddev export-db -z -f ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz | tee ${LOG_DIR}/${CMS_TYPE}-log-${version}.log
  fi

  echo "Stop DDEV ..."
  ddev stop

  echo "Clean DDEV ..."
  ddev delete --omit-snapshot --yes

  echo "Start DDEV ..."
  ddev start

  echo "Import previous DB ..."
  ddev import-db --file=${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz

  echo "Update TYPO3"
#  ddev exec ./operations/update/update-typo3-${version}

  echo "Export current DB ..."
#  ddev export-db -z -f ${DB_BACKUP_DIR}/${version}/typo3-db-${version}-final.sql.gz | tee ${LOG_DIR}/${CMS_TYPE}-log-${version}.log

  # If not last version, stop DDEV and continue with next version
#  if [ "${version}" != "${LAST_VERSION}" ]; then
#    echo "DDEV Stop ..."
#    ddev stop
#  else
#    echo "Upgrade finished!"
#  fi
done
