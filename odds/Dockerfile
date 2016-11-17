
FROM ggrobe/crystax-ndk
MAINTAINER Gary Grobe <gary.l.grobe@nasa.gov>

LABEL Description="Builds OpenDDS for Android."

ADD build-odds.sh /home/developer
ADD acetaodds-build-arm.sh /home/developer
ADD acetaodds-build-x86_64.sh /home/developer
ADD platform_macros.GNU-arm /home/developer
ADD platform_macros.GNU-x86_64 /home/developer
ADD config-android.h /home/developer

RUN chown -R developer:developer /home/developer && \
	chmod -R 755 /home/developer 
 
WORKDIR /home/developer
 
USER developer

CMD "/home/developer/build-odds.sh"

