command -v brew >/dev/null 2>&1 || { 
	echo -e "\033[1;31m Error: Homebrew not installed. Install from here: https://brew.sh/ \033[0m"; exit 1
}

command -v /usr/local/bin/packagesbuild >/dev/null 2>&1 || { 
	echo -e "\033[1;31m Error: Packages util not installed. Install from here: http://s.sudre.free.fr/Software/Packages/about.html  \033[0m"; exit 1
}	

if [ ! -f "qt5.11.1.zip" ]; then
  echo -e "\033[1;32m Downloading Qt \033[0m"
  brew install wget
  wget -O qt5.11.1.zip https://www.dropbox.com/s/0x0knfqfy3x9ud8/qt5.11.1.zip?dl=1
fi

if [ ! -f "qt5.11.1.zip" ]; then
  echo -e "\033[1;31m Downloading Qt failed \033[0m"
  exit 1
fi

if [ ! -d "qt5.11.1" ]; then
  echo -e "\033[1;32m Unzipping Qt \033[0m"
  unzip -q qt5.11.1.zip -d .
fi

if [ ! -d "qt5.11.1" ]; then
  echo -e "\033[1;31m Unzipping Qt failed \033[0m"
  exit 1
fi

echo -e "\033[1;32m Installing dependencies \033[0m"
brew tap owncloud/owncloud
brew install $(brew deps owncloud-client)
brew install cmake qtkeychain openssl@1.1

echo -e "\033[1;32m Downloading source \033[0m"
git clone git://github.com/nextcloud/client.git
cd client
git submodule update --init

echo -e "\033[1;32m Creating build dir \033[0m"
mkdir client-build
cd client-build

echo -e "\033[1;32m Running cmake \033[0m"
cmake ..  -DCMAKE_PREFIX_PATH=/usr/local/opt/qt@5.11 -DCMAKE_INSTALL_PREFIX=../install -DCMAKE_BUILD_TYPE=Debug -DNO_SHIBBOLETH=1 -DQTKEYCHAIN_LIBRARY=/usr/local/opt/qtkeychain/lib/libqt5keychain.dylib -DQTKEYCHAIN_INCLUDE_DIR=/usr/local/opt/qtkeychain/include/qt5keychain -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.1 -DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl@1.1/include -DOPENSSL_LIBRARIES=/usr/local/opt/openssl@1.1/lib -DQt5WebEngineWidgets_DIR=../../qt5.11.1/5.11.1/clang_64/lib/cmake/Qt5WebEngineWidgets -DQt5WebEngine_DIR=../../qt5.11.1/5.11.1/clang_64/lib/cmake/Qt5WebEngine

echo -e "\033[1;32m Running make \033[0m"
make

echo -e "\033[1;32m Running macdeployqt \033[0m"
/usr/local/opt/qt@5.11/bin/macdeployqt bin/nextcloud.app

echo -e "\033[1;32m Creating package \033[0m"
admin/osx/create_mac.sh bin .
