#!/bin/bash

set -ex

if [ -f ${BASH_SOURCE%/*}/.env ]; then
  source "${BASH_SOURCE%/*}/.env"
fi

importDb() {
  gunzip -q </mnt/ddev_config/backup/${CURRENT_CMS_VERSION}/typo3-db-${CURRENT_CMS_VERSION}.sql.gz | mysql -u'db' -p'db' -h'db' db
}

cleanFolders() {
  rm -rf ./public/_assets && rm -rf ./public/typo3 && rm -rf ./public/index.php
  rm -rf ./var && rm -rf ./public/typo3temp
  rm -rf ./vendor
}

composerInstall() {
  composer install${COMPOSER_OPTIONS}
}

warmup() {
  #7.6
  vendor/bin/typo3cms install:generatepackagestates
  vendor/bin/typo3cms install:fixfolderstructure
  vendor/bin/typo3cms install:extensionsetupifpossible
#  vendor/bin/typo3cms language:update

}

upgrade() {
#  vendor/bin/typo3cms database:updateschema
#  vendor/bin/typo3cms upgrade:all
  vendor/bin/typo3cms database:import <${DB_FIXTURES_DIR}${CURRENT_CMS_VERSION}".sql"
  vendor/bin/typo3cms cache:flush
}

importDb
cleanFolders
composerInstall
warmup
upgrade
