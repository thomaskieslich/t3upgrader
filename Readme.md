# Update TYPO3 Versions

Update  ./operations/update/.env

Update
CMS_VERSIONS='11.5 12.4 …'

Always add only the respective version of the current branch in the .env file
That means: if you start in branch 10.4, versions in .env file are only "10.4"
If you create (or switch) to the next branch 11.5, versions in .env file should "10.4 11.5"
In the next branch 12.4, version should be "10.4 11.5 12.4" and so on … That gives you
the possibility of running the upgrade only up to the current branch.

Set current TYPO3 Version
CURRENT_CMS_VERSION='11.5'


## Run TYPO3 Upgrades
```
./operations/update/update-versions
```
