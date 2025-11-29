# Upgrate TYPO3 Versions

Based on:

https://github.com/peter-neumann-dev/ddev-cms-upgrader

https://typo3.org/article/automatic-typo3-updates-across-several-major-versions-with-ddev

Thanks for this work.

I changed the Concept to move the Processes outside of ddev hooks and other things.
The Main Goal is to have one branch for each TYPO3 version and this Script to run the Upgrades
over all Version Branches.
- can change the DB Version between Versions
- can use custom script and DB Fixtures for each version
- can be overwritten in versions-override Folder

The code adjustments for each version still have to be made manually.
However, testing and upgrading with the current live data is much easier.
I usually use https://github.com/thomaskieslich/t3static to test and customise the code.

## Install

1. Create branch with the same Name like the current/legacy TYPO3 Version.

```bash
git checkout -b typo3-13.4
#or with subpath
git checkout -b upgrade/typo3-13.4
```

2. Add this to root .gitignore to have the same code in all project Branches.

```ignore
# TYPO3 Upgrade
# t3upgrader https://github.com/thomaskieslich/t3upgrader
/t3upgrader
```

3. Copy/Clone to Project Root

`git clone git@github.com:thomaskieslich/t3upgrader.git`

4. copy /t3upgrader/.env.dist to /t3upgrader/.env and Update the variables.

5. create .env.t3upgrader in Project Root

```
# TYPO3 Version(s) 7.6 8.7 10.4 11.5 12.4 13.4 14.3 to Upgrade
CMS_VERSIONS='13.4'

# TYPO3 Version of Current Branch
CURRENT_CMS_VERSION='13.4'
```

CMS_VERSIONS and CURRENT_CMS_VERSION should be identical in the Version you Start.

Always add only the respective version of the current branch in the .env.upgrader file
That means: if you start in branch 12.4, versions in .env.upgrader file are only "12.4"
If you create (or switch) to the next branch 13.4, versions in .env file should "12.4 13.4"
In the next branch 14.3, version should be "12.4 13.4 14.3" and so on … That gives you
the possibility of running the upgrade only up to the current branch.
In Development testing you can set both versions to the current TYPO3 Version only.

## Run TYPO3 Upgrades from project Root

```
./t3upgrader/t3upgrade.sh
```

## Explanations

### .env

#### CMS_VERSIONS

Is changed per update branch (see below). All versions from starting version to current branch version

```
CMS_VERSIONS='12.4 13.4 14.3'
```

#### CURRENT_CMS_VERSION

Current branch version

Branch: typo3-13.4

```
CURRENT_CMS_VERSION='13.4'
```

Branch: typo3-14.3

```
CURRENT_CMS_VERSION='14.3'
```

### t3upgrader/.env

BASE_CMS_VERSION
Starting version

```
BASE_CMS_VERSION='12.4'
```

### Branches

Branches are expected with following names
{BRANCH_PREFIX}-{CMS_VERSIONS[0]}
{BRANCH_PREFIX}-{CMS_VERSIONS[1]}
etc.

```
BRANCH_PREFIX='typo3'
CMS_VERSIONS='12.4 13.4 14.3'
```

typo3-12.4
typo3-13.4
typo3-14.3

### t3upgrader/versions/xx.xx

db-fixtures.sql
Possibility to set db changings

Additionally you can put additional scripts there and add it to update-script.sh (example below)

## Example steps v12 to v14

1. t3upgrader/.env adjust all values if necessary (CMS_VERSIONS and CURRENT_CMS_VERSION remain commented out)
    * ```BASE_CMS_VERSION='12.4'``` (Starting version)
2. run sync script
3. Checkout new branch for 12.4: ```git checkout -b upgrade/typo3-12.4```
5. Create root-.env.t3upgrader with CMS_VERSIONS and CURRENT_CMS_VERSION
    * ```CMS_VERSIONS='12.4'```
    * ```CURRENT_CMS_VERSION='12.4'```
6. commit state, because upgrader will switch between branches
7. ```./t3upgrader/t3upgrade.sh```
9. Checkout new branch for 13.4: ```git checkout -b upgrade/typo3-13.4```
10. Adjust root-.env.t3upgrader
    * ```CMS_VERSIONS='12.4 13.4'```
    * ```CURRENT_CMS_VERSION='13.4’```
11. set needed package versions and php version to composer.json, set needed php version to .ddev/config
    1. ```ddev restart```
    2. ```ddev composer u``` to test that all versions are correct
12. commit state, because upgrader will switch between branches
13. ```./t3upgrader/t3upgrade.sh```
14. Checkout new branch for 14.3: ```git checkout -b upgrade/typo3-14.3```
15. Root-.env.t3upgrader anpassen
    * ```CMS_VERSIONS='12.4 13.4 14.3’```
    * ```CURRENT_CMS_VERSION='14.3’```
16. set needed package versions and php version to composer.json, set needed php version to .ddev/config
    1. ```ddev restart```
    2. ```ddev composer u``` to test that all versions are correct
17. commit state, because upgrader will switch between branches
18. ```./t3upgrader/t3upgrade.sh```

## Additional migrations

### Example: Migration of gridlements to container at v12

1. remove gridelementsteam/gridelements from composer.json
2. add b13/container to composer.json
3. create migration script and put it in t3upgrader/versions/x.x
4. Add line to upgrade-script.sh inside t3upgrader/versions/x.x to run script
5. optional: you can put the lines directly in upgrade-script.sh

Example

```
ddev typo3 gridtocontainer:migrateall 1 container_2columns_8-4 clean 0,1 200,201
ddev typo3 gridtocontainer:migrateall 2 container_2columns_6-6 clean 0,1 200,201
ddev typo3 gridtocontainer:migrateall 3 container_4columns_3-3-3-3 clean 0,1,2,3 200,201,202,203
ddev typo3 gridtocontainer:migrateall 4 container_3columns_4-4-4 clean 0,1,2 200,201,202
```

### Keep at specific version

You can set the CMS_VERSIONS to a specific version, so you can run the upgrader only for that one, if you need it

```
CMS_VERSIONS='13.4'
CURRENT_CMS_VERSION='13.4'
``
