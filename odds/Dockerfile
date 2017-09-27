
FROM ggrobe/crystax-ndk
MAINTAINER Gary Grobe <gary.l.grobe@nasa.gov>

LABEL Description="Builds OpenDDS for Android."

ADD build-odds.sh /home/developer
ADD acetaodds-build-arm.sh /home/developer
ADD acetaodds-build-x86_64.sh /home/developer
ADD platform_macros.GNU-arm /home/developer
ADD platform_macros.GNU-x86_64 /home/developer
# Adding these two files is only needed until pull requests is added and 
# ACE 6.3.2 is added to DDS 3.12.
ADD platform_android.GNU /home/developer
ADD config-android.h /home/developer
ADD opendds.patch /home/developer

USER root

RUN chown -R developer:developer /home/developer && \
	chmod -R 755 /home/developer 
 
WORKDIR /home/developer
 
USER developer

CMD "/home/developer/build-odds.sh"

