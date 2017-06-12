
FROM gentoo/stage3-amd64-nomultilib
MAINTAINER Gary Grobe <gary.l.grobe@nasa.gov>

LABEL Description="Installs Crystax toolchain for Android on a Gentoo base."

RUN mkdir -p /usr/portage && \
	mkdir -p /etc/portage/repos.conf && \
	mkdir -p /usr/portage/metadata && \
	echo "masters = gentoo" > /usr/portage/metadata/layout.conf && \
	echo "[DEFAULT]" > /etc/portage/repos.conf/gentoo.conf && \
	echo "main-repo = gentoo" >> /etc/portage/repos.conf/gentoo.conf && \
	echo "" >> /etc/portage/repos.conf/gentoo.conf && \
	echo "[gentoo]" >> /etc/portage/repos.conf/gentoo.conf && \
	echo "location = /usr/portage" >> /etc/portage/repos.conf/gentoo.conf && \
	echo "sync-type = webrsync" >> /etc/portage/repos.conf/gentoo.conf && \
	echo "sync-uri = rsync://rsync.gentoo.org/gentoo-portage" >> /etc/portage/repos.conf/gentoo.conf && \
	emerge --sync && \
	emerge gcc && \
	gcc-config 2 && \
	chmod 777 /opt && \
	/usr/sbin/useradd -d /home/developer -m -s /bin/bash developer

#	emerge-webrsync && 
#	emerge tar && 

USER developer 

ENV CRY_DIR=/home/developer/crystax-ndk-10.3.2 \
	CRY_WEB=https://dl.crystax.net/builds/912/linux \
	CRY_FILE=crystax-ndk-10.3.2-b912-linux-x86_64.tar.xz \
	CRY_DEST=/opt/crystax-ndk

RUN cd /home/developer && \
	wget $CRY_WEB/$CRY_FILE && \
	tar xf ./$CRY_FILE && \
	cd $CRY_DIR

# this make apparently needs to be separated from previous RUN commands
RUN	$CRY_DIR/build/tools/make-standalone-toolchain.sh \
		--system=linux-x86_64 \
		--toolchain=aarch64-linux-android-5 \
		--platform=android-24 \
		--install-dir=$CRY_DEST 


#		arm-linux-androideabi-5 
#	tar xvfJ $CRY_FILE && 
#	mkdir /opt/crystax-ndk
