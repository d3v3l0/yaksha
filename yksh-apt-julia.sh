#!/usr/bin/env bash
################################################################################
# FILE       : yakshara-julia-aptinstall.sh
# DESCRIPTION: Installation script for the Julia source build.
# AUTHOR     : SVAKSHA, http://svaksha.com/pages/Bio
# SOURCE     : http://svaksha.github.io/yaksha
# COPYRIGHT© : 2005-Now SVAKSHA, All Rights Reserved.
# LICENSE    : GNU AGPLv3 and subject to meeting all the terms in the LICENSE 
#              file: https://github.com/svaksha/yaksha/blob/master/LICENSE.md
# DATES      : Created:2015feb15 - Updated:2016feb29
################################################################################
#
#-------------------------------------------------------------------------------
# install julia from the distro PPA nightlies
#-------------------------------------------------------------------------------

echo "Installation of julia (PPA nightlies) will start!"

# Set debug mode
exec 5> >(logger -t $0) # uses logger command 
BASH_XTRACEFD="5"
PS4='$LINENO: '
set -x
# set +x # Turn off the log verbiage.


function install_jl_ubuntu_ppanightlies() {
    sudo add-apt-repository --yes ppa:staticfloat/juliareleases
    sudo add-apt-repository --yes ppa:staticfloat/julia-deps
    sudo add-apt-repository --yes ppa:staticfloat/julianightlies
    sudo apt-get -y update && sudo apt-get -y upgrade
    sudo apt-get -y install julia
    julia --eval 'Pkg.add("IJulia")' # Better to keep this in juliarc/REQUIRE ??
    julia --eval 'Pkg.add("Gadfly")'
} # End function install_jl_ppanightlies


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# An experimental script to automatically update julia
# From, https://gist.github.com/jiahao/3f9826b077372220b6f0
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


JULIADIR=$HOME/julia   #TODO: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in?rq=1
cd $JULIADIR
set -e                   # stop on error

#-------------------------------------------------------------------------------
# install julia from git master
#-------------------------------------------------------------------------------
function install_jl_gitdev() {

# Check all dynamic library dependencies to detect potentially missing dependencies
    for LIB in `find deps -name "*.dylib"`; do
  # Find dependencies that have absolute paths
      LIBDEPS=$(otool -L $LIB | grep -v : | grep -v @ | grep \/ | cut -f1 -d\()
  
  # If dependency is missing, assume that the external library was upgraded and
  # version number got bumped.
      for filename in $LIBDEPS; do
        if test ! -e $filename; then
          echo "WARNING: $LIB: Could not find dynamic library dependency" $filename
          echo "Wiping all dependencies to trigger rebuild"
          make -C deps cleanall
          make -C deps distclean-libgit2 && make
          break 2
        fi
      done
    done

git clone git@github.com:JuliaLang/julia.git

# Check if ~/julia exists
#---------------------------
if [ -e /usr/local/bin/julia ]; then
    echo "Julia folder already exists on localhost. Exiting!"
    exit 1
fi

# Rebuild at all costs
# OpenBLAS without threads
#--------------------------
if [ $? -ne "0" ]; then
    make -C deps clean-openblas 
    make OPENBLAS_TARGET_ARCH=NEHALEM OPENBLAS_USE_THREAD=0
    make OPENBLAS_DYNAMIC_ARCH=0
fi

if [test $? -ne "0"] ; then
  make
  make clean
fi

if test $? -ne 0 ; then
  make cleanall
  make
fi

if test $? -ne 0; then 
  git clean -fdx         #nukes all your installed dependencies
  make
fi

# Was there an error ?
if [ $? -ne "0" ]; then
 echo "ERROR"
 exit 1; 
fi

} # End function install_jl_gitdev

echo "Installation of julia (git master) is done!"

#Update Julia packages
$HOME/julia -e 'Pkg.update()'


# case install julia
#-------------------------------------------------------------------------------
case $install_julia in
    jl_gitdev)
        install_jl_gitdev
    ;;
    jl_ppanightlies)
        install_jl_ubuntu_ppanightlies
    ;;
    all)
        install_jl_gitdev
        install_jl_ubuntu_ppanightlies
    ;;
    *)
        echo "Installation in progress, almost done!"
    esac


