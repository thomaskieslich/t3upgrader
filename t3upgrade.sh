#!/bin/bash

# stop script when an error occured
set -e

# Get base Settings
if [ -f ${BASH_SOURCE%/*}/.env ]; then
  source "${BASH_SOURCE%/*}/.env"
fi

# get Version Settings
source "${ROOT_ENV_FILE}"

VERSIONS=(${CMS_VERSIONS})

# Get last version to upgrade to
LAST_VERSION=${VERSIONS[@]: -1}

# Create Directories
mkdir -p ${DB_BACKUP_DIR}

splitVersions() {
  if [[ $version == *.* ]]; then
    major_version="${version%%.*}"
    minor_version="${version##*.}"
  else
    major_version=$version
    minor_version=0
  fi
}

initUpgrade() {
  echoStep "Create DB Backup Dir \n mkdir -p ${DB_BACKUP_DIR}/${version}"
  mkdir -p ${DB_BACKUP_DIR}/${version}

  if [ "${version}" = "${BASE_CMS_VERSION}" ]; then

    # put backup-file in t3upgrader-path
    # if it is plain sql, we have to compress it before
    if [[ "$BASE_DB" == *.sql ]]; then
      echoStep "DB base dump is plain .sql-file – compressing with gzip and copy... \n gzip -c ${BASE_DB} > ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz"
      gzip -c ${BASE_DB} > ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz
    else
      echoStep "Copy Production DB \n cp ${BASE_DB} ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz"
      cp ${BASE_DB} ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz
    fi
  else
    echoStep "Export current DB ... \n ddev export-db -z -f ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz"
    ddev export-db -z -f ${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz
  fi

  echoStep "Checkout ${version} branch ... \n git checkout ${BRANCH_PREFIX}-${version}"
  git checkout ${BRANCH_PREFIX}-${version}
}

importCleanDB() {
  echoStep "Stop DDEV ... \n ddev stop"
  ddev stop

  echoStep "Clean DDEV ... \n ddev delete --omit-snapshot --yes"
  ddev delete --omit-snapshot --yes

  echoStep "Start DDEV ... \n ddev start"
  ddev start

  echoStep "Import previous DB ... \n ddev import-db --file=${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz"
  ddev import-db --file=${DB_BACKUP_DIR}/${version}/typo3-db-${version}.sql.gz
}

cleanFolders() {
  echoStep "Clean Folders ..."
  rm -rf ./public/typo3conf/ext && rm -rf ./public/typo3conf/l10n
  rm -rf ./public/_assets && rm -rf ./public/typo3 && rm -rf ./public/index.php
  rm -rf ./var && rm -rf ./public/typo3temp
  rm -rf ./vendor

  ## clean system Folder if necessary
#  if [ "$major_version" -lt 12 ]; then
#    rm -rf ./config/system
#  fi
}

composerInstall() {
  ddev composer install${COMPOSER_OPTIONS}
}

updateTYPO3() {
  echoStep "Update TYPO3 \n ddev exec ${VERSIONS_DIR}/${version}/update-script.sh"
  ddev exec ${VERSIONS_DIR}/${version}/update-script.sh
}

finishUpgrade() {
  echoStep "Export current DB ... \n ddev export-db -z -f ${DB_BACKUP_DIR}/${version}/typo3-db-${version}-final.sql.gz"
  ddev export-db -z -f ${DB_BACKUP_DIR}/${version}/typo3-db-${version}-final.sql.gz

  # If not last version, stop DDEV and continue with next version
  if [ "${version}" != "${LAST_VERSION}" ]; then
    echoStep "DDEV Stop ... \n ddev stop"
    ddev stop
  else
    echoStep "Upgrade finished!"
  fi
}

# issue echo commands with more visual means
echoStep() {
    echo -e "\n\033[1;34m==> $1\033[0m\n"
}

# Loop through versions and upgrade step by step
for version in "${VERSIONS[@]}"; do
  splitVersions
  initUpgrade
  importCleanDB
  cleanFolders
  composerInstall
  updateTYPO3
  finishUpgrade
done
