#!/usr/bin/env bash

REPO_URL="https://github.com/NWChemEx/NWChemEx.git"
NWCHEMEX_DIR=`pwd`/NWChemEx
INSTALL_DIR=$NWCHEMEX_DIR/install

echo "Cloning NWChemEx Repository"
if [[ -d "NWChemEx" ]]; then
  echo "NWChemEx folder exists"
else
  git clone "$REPO_URL"
fi

cd ./NWChemEx

if ! python3 -c "import venv" &> /dev/null; then
  echo "venv not installed"
  exit 1;
else
  echo "venv installed"
fi

if [[ ! -d ".venv" ]]; then
  python3 -m venv .venv
  source ./.venv/bin/activate
else
  source ./.venv/bin/activate
  pip install ase networkx qcengine qcelemental setuptools
fi
  

if [[ -d "build" ]]; then
  echo "The 'build' directory exists"
  rm -rf build
fi

VERSION=2.9.0
wget https://github.com/evaleev/libint/releases/download/v${VERSION}/libint-${VERSION}.tgz
tar -zxf libint-${VERSION}.tgz

LIBINT2_DIR=`pwd`/libint-${VERSION}
LIBINT2_INSTALL=`pwd`/libint-${VERSION}/install
cd libint-${VERSION}
cmake -B build -S . -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DCMAKE_INSTALL_PREFIX=$LIBINT2_DIR/install
cmake --build build --target install --parallel

cd $NWCHEMEX_DIR
CMAKE_FLAGS="-DNWX_MODULE_DIRECTORY=$INSTALL_DIR "
CMAKE_FLAGS+="-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR "
CMAKE_FLAGS+="-DCMAKE_PREFIX_PATH=$LIBINT2_INSTALL "
CMAKE_FLAGS+="-DBUILD_SHARED_LIBS=ON "
CMAKE_FLAGS+="-DCMAKE_POSITION_INDEPENDENT_CODE=ON "
CMAKE_FLAGS+="-DCMAKE_CXX_STANDARD=17 "
cmake -S . -B build $CMAKE_FLAGS


