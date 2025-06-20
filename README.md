# NWChemEx Unofficial Install Script

Currently this scrips performs the NWChemEx setup for Ubuntu 24.04 LTS. To install NWChemEx via this script,
you will need to first install the necessary packages for NWChemEx and its dependencies via the following
command:

```bash
sudo apt update && sudo apt upgrade
sudo apt install python3.12-venv \
cmake \
build-essential \
git \
libopenmpi-dev \
python3.12-dev \
libboost-dev \
nwchem \
wget \
libeigen3-dev \
libopenblas-dev
```

With the dependencies installed, you can then navigate to your desired install path and clone this repository and
start the install process:

```bash
git clone https://github.com/jlheflin/NWChemEx-BashInstallScript.git
cd NWChemEx-BashInstallScript
bash ./install_nwchemex.sh
```

This will clone the NWChemEx stack, the Libint2 source package, and build both from source using cmake. All necessary
paths and exports will then be printed out to a file called `setup_env.sh`, from there you can source the file and
have a working environment for NWChemEx:

```bash
source ./setup_env.sh
```

This will export the PYTHONPATH and LD_LIBRARY_PATH variables, rendering the shell ready for Python development 
activities.


To test that the environment setup is working, you can run the follwing commands:

```bash
python3.12 -c "import friendzone"
python3.12 -c "import nwchemex"
python3.12 -c "import chemcache"
python3.12 -c "import chemist"
python3.12 -c "import integrals"
python3.12 -c "import nux"
python3.12 -c "import parallelzone"
python3.12 -c "import pluginplay"
python3.12 -c "import scf"
python3.12 -c "import simde"
python3.12 -c "import tensorwrapper"
```

If you encounter no errors, you have successfully sourced the `setup-env.sh` file and are ready to start using
NWChemEx!


The `install_nwchemex.sh` script can be modified to specify the specific version of Libint2, or even the specific URL
you want to pull NWChemEx from. This script was made to be as hands off as possible for the user, so if you encounter 
issues please let me know!
