
FROM gentoo/stage3-amd64-nomultilib
MAINTAINER Gary Grobe <gary.l.grobe@nasa.gov>

LABEL Description="Installs Crystax toolchain for Android from Gentoo base."

RUN mkdir -p /usr/portage && \
	emerge-webrsync && \
	emerge tar && \
	/usr/sbin/useradd -d /home/developer -m -s /bin/bash developer

ENV CRY_DIR=/home/developer/crystax-ndk-10.3.2 \
	CRY_WEB=https://www.crystax.net/download \
	CRY_FILE=crystax-ndk-10.3.2-linux-x86_64.tar.xz \
	CRY_DEST=/opt/crystax-ndk

RUN cd /home/developer && \
	wget $CRY_WEB/$CRY_FILE && \
	tar xvfJ $CRY_FILE && \
	mkdir /opt/crystax-ndk && \
	$CRY_DIR/build/tools/make-standalone-toolchain.sh \
		--system=linux-x86_64 \
		--toolchain=arm-linux-androideabi-4.9 \
		--platform=android-21 \
		--install-dir=$CRY_DEST && \
	chown -R developer:developer /home/developer && \
	chmod -R 755 /home/developer


