# Experimental NextCloud build script for Mac

## Prerequisites:
* XCode 10 with command line tools
* Homebrew:
```console
/usr/bin/ruby -e “$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)”
```
* [Packages](http://s.sudre.free.fr/Software/Packages/about.html)

## Instructions:

### Build 
```console
./mac_build.sh
```
Upon successful build, package will be located at `client/install/Nextcloud-version.pkg`

### Sign package:
```console
productsign --sign "My Identity" client/install/Nextcloud-version.pkg client/install/Nextcloud-version-signed.pkg
```







