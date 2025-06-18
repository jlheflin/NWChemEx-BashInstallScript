#!/usr/bin/env bash

TOP_DIR=`pwd`
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

if ! python3.12 -c "import venv" &> /dev/null; then
  echo "venv not installed"
  exit 1;
else
  echo "venv installed"
fi

if [[ ! -d ".venv" ]]; then
  python3.12 -m venv .venv
  source ./.venv/bin/activate
  pip install ase networkx qcengine qcelemental setuptools
else
  source ./.venv/bin/activate
  pip install ase networkx qcengine qcelemental setuptools
fi
  
VERSION=2.9.0
if [[ ! -f libint-${VERSION}.tgz ]]; then
  wget https://github.com/evaleev/libint/releases/download/v${VERSION}/libint-${VERSION}.tgz
fi

if [[ ! -d libint-${VERSION} ]]; then
  tar -zxf libint-${VERSION}.tgz > /dev/null 2>&1
fi

LIBINT2_DIR=`pwd`/libint-${VERSION}
LIBINT2_INSTALL=`pwd`/libint-${VERSION}/install
cd libint-${VERSION}
cmake -B build -S . -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DCMAKE_INSTALL_PREFIX=$LIBINT2_DIR/install
cmake --build build --target install --parallel 4

cd $NWCHEMEX_DIR
CMAKE_FLAGS="-DNWX_MODULE_DIRECTORY=$INSTALL_DIR "
CMAKE_FLAGS+="-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR "
CMAKE_FLAGS+="-DCMAKE_PREFIX_PATH=$LIBINT2_INSTALL "
CMAKE_FLAGS+="-DBUILD_SHARED_LIBS=ON "
CMAKE_FLAGS+="-DCMAKE_POSITION_INDEPENDENT_CODE=ON "
CMAKE_FLAGS+="-DCMAKE_CXX_STANDARD=17 "

if [[ -d "build" ]]; then
  echo "The 'build' already directory exists, reseting variables"
  cmake -U "*" -S . -B build $CMAKE_FLAGS
else
  cmake -S . -B build $CMAKE_FLAGS
fi
cmake --build build --target install --parallel 4

cd ./install/lib
ln -s ./chemcache/libchemcache.so.1 .
ln -s ./chemist/libchemist.so.1 .
ln -s ./integrals/libintegrals.so.0 .
ln -s ./parallelzone/libparallelzone.so.0 .
ln -s ./pluginplay/libpluginplay.so.1 .
ln -s ./tensorwrapper/libtensorwrapper.so.0 .
ln -s ./utilities/libutilities.so.0 .
ln -s $NWCHEMEX_DIR/build/_deps/scf-build/libscf.so .
ln -s $NWCHEMEX_DIR/build/_deps/nux-build/libnux.so .

cd $TOP_DIR
cat <<EOF > setup_env.sh
# Setup python environment
source ${NWCHEMEX_DIR}/.venv/bin/activate
export LD_LIBRARY_PATH=${NWCHEMEX_DIR}/install/lib:\$LD_LIBRARY_PATH
export PYTHONPATH=${NWCHEMEX_DIR}/install
EOF

echo "Setup Complete! NEAT!!!"
