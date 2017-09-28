#!/bin/bash
#
# This script builds ACE+TAO+DDS for x86_64.
#

HOME=/home/developer
BUILD_TOP=/home/developer/arm-tools
DDS_REL=OpenDDS-3.11

unpack_files() {
	cd $BUILD_TOP

	# Prepare source for this build as well as the one to follow for the arm.
	#local HTTP_AT=http://download.ociweb.com/TAO-2.2a
	#local HTTP_DDS=http://download.ociweb.com/OpenDDS
	local HTTP_DDS=download.ociweb.com/OpenDDS/previous-releases
	# This version from Vanderbilt fixes CPU_SET_T conflicts.
    local HTTP_AT=download.dre.vanderbilt.edu/previous_versions

	#local FILE_AT=ACE+TAO-2.2a_with_latest_patches_NO_makefiles.tar.gz
	local FILE_AT=ACE+TAO-6.4.3.tar.gz
	local FILE_DDS=$DDS_REL.tar.gz

	wget $HTTP_AT/$FILE_AT
	wget $HTTP_DDS/$FILE_DDS

	tar -xvzf ./$FILE_AT
	tar -xvzf ./$FILE_DDS
}

apply_patches() {
	cd $HOME
	patch -p0 < opendds.patch
}

set_build_env() {
	cd $BUILD_TOP/ACE_wrappers

	./MPC/clone_build_tree.pl x86_64
	cd build/x86_64

	export ACE_ROOT=$PWD
	export MPC_ROOT=$ACE_ROOT/MPC
	export TAO_ROOT=$ACE_ROOT/TAO

	echo "ACE_ROOT = $ACE_ROOT"
	echo "MPC_ROOT = $MPC_ROOT"
	echo "TAO_ROOT = $TAO_ROOT"

	cd $BUILD_TOP/$DDS_REL
	
	$MPC_ROOT/clone_build_tree.pl x86_64

	cd build/x86_64

	export DDS_ROOT=$PWD
}

configure_ace() {
	echo '#include "ace/config-linux.h"' > $ACE_ROOT/ace/config.h

	cp $HOME/platform_macros.GNU-x86_64 \
		$ACE_ROOT/include/makeinclude/platform_macros.GNU
}

generate_makefiles() {
	cd $TAO_ROOT
	perl $ACE_ROOT/bin/mwc.pl -type gnuace ./TAO_ACE.mwc

	cd $DDS_ROOT
	perl $ACE_ROOT/bin/mwc.pl DDS.mwc -type gnuace
}

compile() {
	cd $ACE_ROOT
	make -C ace
	make -C apps/gperf/src

	cd $TAO_ROOT
	make -C TAO_IDL

	cd $DDS_ROOT
	make -C dds/idl
}

unpack_files
apply_patches
set_build_env
configure_ace
generate_makefiles
compile

