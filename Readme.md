# Upgrate TYPO3 Versions

Set TYPO3 Versions to Root.env

```
# t3upgrader CMS_VERSIONS='7.6 8.7 10.4 11.5 12.4 13.4' move to root .env
CMS_VERSIONS='7.6 8.7 10.4 11.5 12.4 13.4'
CURRENT_CMS_VERSION='7.6'
```


Always add only the respective version of the current branch in the .env file
That means: if you start in branch 10.4, versions in .env file are only "10.4"
If you create (or switch) to the next branch 11.5, versions in .env file should "10.4 11.5"
In the next branch 12.4, version should be "10.4 11.5 12.4" and so on … That gives you
the possibility of running the upgrade only up to the current branch.

## Run TYPO3 Upgrades from project Root
```
./t3upgrader/t3upgrade.sh
```

## Explanations

### .env

#### CMS_VERSIONS
Is changed per update branch (see below). All versions from starting version to current branch version
```
CMS_VERSIONS='10.4 11.5 12.4'
```

#### CURRENT_CMS_VERSION
Current branch version

Branch: typo3-11.5
```
CURRENT_CMS_VERSION='11.5'
```

Branch: typo3-12.4
```
CURRENT_CMS_VERSION='12.4'
```

### t3upgrader/.env
BASE_CMS_VERSION
Starting version
```
BASE_CMS_VERSION='10.4'
```

### Branches

Branches are expected with following names
{BRANCH_PREFIX}-{CMS_VERSIONS[0]}
{BRANCH_PREFIX}-{CMS_VERSIONS[1]}
etc.
```
BRANCH_PREFIX='typo3'
CMS_VERSIONS='10.4 11.5'
```
typo3-10.4
typo3-11.5


### t3upgrader/versions/xx.xx
db-fixtures.sql
Possibility to set db changings

Additionally you can put additional scripts there and add it to update-script.sh (example below)

## Example steps v10 to v12

1. t3upgrader/.env adjust all values if necessary (CMS_VERSIONS and CURRENT_CMS_VERSION remain commented out)
    * ```BASE_CMS_VERSION='10.4'``` (Starting version)
2. run sync script
3. Checkout new branch for 10.4: ```git checkout -b typo3-10.4```
5. Create root-.env with CMS_VERSIONS and CURRENT_CMS_VERSION
    * ```CMS_VERSIONS='10.4'```
    * ```CURRENT_CMS_VERSION='10.4'```
6. commit state, because upgrader will switch between branches
7. ```./t3upgrader/t3upgrade.sh```
9. Checkout new branch for 11.5: ```git checkout -b typo3-11.5```
10. Adjust root-.env
    * ```CMS_VERSIONS='10.4 11.5'```
    * ```CURRENT_CMS_VERSION='11.5’```
11. set needed package versions and php version to composer.json, set needed php version to .ddev/config
    1. ```ddev restart```
    2. ```ddev composer u``` to test that all versions are correct
12. commit state, because upgrader will switch between branches
13. ```./t3upgrader/t3upgrade.sh```
14. Checkout new branch for 12.4: ```git checkout -b typo3-12.4```
15. Root-.env anpassen
    * ```CMS_VERSIONS='10.4 11.5 12.4’```
    * ```CURRENT_CMS_VERSION='12.4’```
16. set needed package versions and php version to composer.json, set needed php version to .ddev/config
    1. ```ddev restart```
    2. ```ddev composer u``` to test that all versions are correct
17. commit state, because upgrader will switch between branches
18. ```./t3upgrader/t3upgrade.sh```

## Additional migrations

### Example: Migration of gridlements to container at v12

WIP: not implemented yet, its only theoretically
WIP: add real implementation after did it practically

1. remove gridelementsteam/gridelements from composer.json
2. add b13/container to composer.json
3. create migration script and put it in t3upgrader/versions/x.x
4. Add line to upgrade-script.sh inside t3upgrader/versions/x.x to run script

### Keep at specific version

You can set the CMS_VERSIONS to a specific version, so you can run the upgrader only for that one, if you need it

```
CMS_VERSIONS='11.5'
CURRENT_CMS_VERSION='11.5'
``
