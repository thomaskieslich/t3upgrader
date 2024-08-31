# Upgrate TYPO3 Versions

Set TYPO3 Versions to Root.env

```
# t3upgrader CMS_VERSIONS='7.6 8.7 10.4 11.5 12.4' move to root .env
CMS_VERSIONS='7.6'
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
