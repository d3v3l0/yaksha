This is a list of design ideas that I would like to implement for automating my system packages installation process. 

Currently, the structure is as listed in the "Current Design" section while the "Manifesto" section describes actionable design tasks that are on my TODO list or a WIP. 

Hopefully having them listed as a manifesto will reduce ad-hoc changes and introduce more stability via planned design changes.

# Manifesto

## /kern folder 
* The central processing tasks go here. 
* All central system components responsible for running or executing the daemon programs: 
   + a central dotfiles manager - see stow, https://www.gnu.org/software/stow/
        + http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
   + an encryption manager for the private files - ex. should use yakshi to encrypt and decrypt private repo files.
* The kernel is responsibile for decision tasks involving running/executing other programs.
* The kernel will also be responsible for deciding order of tasks and processes.
   + it should give the user the option to choose what to install:
        + only dotfiles
        + only julia related pkgs, etc.
* Input/output (I/O) tasks management: For all IO tasks, the request allocation is handled via core programs.
* Use [shellcheck](https://github.com/koalaman/shellcheck), a static analysis tool for shell scripts https://www.shellcheck.net

----

# Current Design

### 1. Programs

+ __yaksha.sh__ :: This daemon will be wired to run all the program scripts listed below automatically. {WIP, Not Recommended.}

### 2. Folders
+ __/backup/__ :: Backup script using the attic python lib. {Tag: unmaintained}
+ __/debian__ : {Tag: unmaintained}
    + `apt-debian.sh` :: An automated system installation shell script for all new Debian Jessie machines that installs the following developer stack: 
        * Atom, Vim, basher, tab completion, curl, git, GNU core utils, etc..
        * Anaconda, VirtualBox, Vagrant, Docker, etc..
        * {Database}: MySQL, PostgreSQL, SQLite, MongoDB, etc..
        * {Languages}: GCC, G++, Go, Python, Java, Javascript, R, Ruby, et al.
    + `vm-debian8.sh` :: {WIP} The dependencies for a VM running debian-8 (jessie).
+ __/docker/__ :: The dockerfiles are a WIP.
+ __/etc/__ :: copy of the `sources.list` for apt.
+ __/git/__ :: automate git ...
    + `git-extract-commits.sh` :: extracts commits for GSoC commits, Original gist, https://gist.github.com/xinan/42669b49153af52919b2
    + `gitlab-omni.sh` :: Program to automatically check the OS and install the `gitlab` version.
    + `gitlab.sh` :: Bash script to install the `gitlab` omnibus version. Use __gitlab-omni.sh__ instead.
    + `gitup.sh` :: Automagically update all the local GIT repos.
+ __/home/__ :: Home dotfiles and config folders for `bash`, `.julia`, `.vim`, etc..
+ __/julia__ :
    + `env.jl` :: devel env settings. 
    + `jl-binary.sh` :: Generic Linux binaries installation script for Julia stable releases.
    + `jl-colors-migrate.sh` :: Prof. Tim Holy's script.
    + `jl-gitDEV.sh` :: This script installs __Julia__ and builds from the unstable master on github. {__Nota Bene__: I use the _master build_, so _dont_ use this script if you want stable Julia packages - some packages may have bugs and may not work with the DEV build.}
    + `update.sh` :: Updates and builds the julia unstable master installed via `julia-stable.sh`
    + `yaksha.jl` :: julia module for yaksha.
+ __/linuxkernel/__:: Scripts for removing old kernels. 
+ __/kubuntu__:: scripts for installing OS applications and the package dependencies, updates, etc.. {Tag: unmaintained}
+ __/opensuse__ : {Tag: unmaintained}
    + `zyppr-opensuse.sh` :: The shell script for RPM-based OpenSUSE packages.
+ __/python__ :: 
    + `anaconda3.sh` :: Installs Anaconda3.
    + `pypip.sh` :: Bash script to install PYTHON packages using pip/pip3.
+ __/ubuntu__:: Script to install basic Ubuntu packages, including non-free applications. 
    + `apt-install.sh`
    + `apt-install-nonfree.sh`
    + `apt-remove-amazon.md`
    + `apt-update-ubuntu.sh` 

 


