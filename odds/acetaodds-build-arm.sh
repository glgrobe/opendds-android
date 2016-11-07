#!/bin/bash
#
# This script builds ACE+TAO+DDS for arm and relies on tools from an existing
# x86_64 build.
#

HOME=/home/developer
BUILD_TOP=/home/developer/arm-tools

#export NDK=/home/developer/crystax-ndk-10.3.2
export ANDROID_ARCH=arm
export CROSS_COMPILE=arm-linux-androideabi-
export TOOLCHAIN=/opt/crystax-ndk
#export SYSROOT=${NDK}/platforms/android-21/arch-${ANDROID_ARCH}
export SYSROOT=${TOOLCHAIN}/sysroot
export PATH=${TOOLCHAIN}/bin:${PATH}

export CFLAGS="${CFLAGS} --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${TOOLCHAIN}/include"
export CPPFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS} -L${SYSROOT}/usr/lib -L/opt/android-prefix/lib"
export LD_LIBRARY_PATH=${ACE_ROOT}/lib:${DDS_ROOT}/lib:${LD_LIBRARY_PATH}

set_build_env() {

	cd $BUILD_TOP/ACE_wrappers
	./MPC/clone_build_tree.pl arm
	cd build/arm

	export ACE_ROOT=$PWD
	export MPC_ROOT=${ACE_ROOT}/MPC
	export TAO_ROOT=${ACE_ROOT}/TAO

	cd $BUILD_TOP/OpenDDS-3.9
	${MPC_ROOT}/clone_build_tree.pl arm
	cd build/arm

	export DDS_ROOT=$PWD
}

configure_ace() {
	cp $HOME/config-android-crystaxNDK.h ${ACE_ROOT}/ace

	echo '#include "ace/config-android-crystaxNDK.h"' > \
		${ACE_ROOT}/ace/config.h

	cp $HOME/platform_macros.GNU-arm \
		${ACE_ROOT}/include/makeinclude/platform_macros.GNU

	cd ${ACE_ROOT}/bin
	ln -sf ../../x86_64/bin/tao_idl
}

generate_makefiles() {
	cd ${TAO_ROOT}
	perl ${ACE_ROOT}/bin/mwc.pl -type gnuace TAO_ACE.mwc

	cd ${DDS_ROOT}/bin
	ln -sf ../../x86_64/bin/opendds_idl

	cd ${DDS_ROOT}
	perl ${ACE_ROOT}/bin/mwc.pl DDS.mwc -type gnuace
}

compile() {
	echo "calling make -C ace"
	cd ${ACE_ROOT}
	make -C ace

	echo "calling TAO_ROOT make"
	cd ${TAO_ROOT}
	make

	echo "calling DDS_ROOT make"
	cd ${DDS_ROOT}
	make

	cd ${ACE_ROOT}/bin
	ln -sf ../TAO/TAO_IDL/tao_idl 
}

# Files are downloaded and unpacked by acetaodds-build-x86_64.sh
# which is run before acetaodds-build-arm.sh (this script).
set_build_env
configure_ace
generate_makefiles
compile

