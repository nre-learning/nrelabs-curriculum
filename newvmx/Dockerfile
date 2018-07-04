FROM marcelwiget/vmx-docker-light

COPY launch.sh /
RUN chmod a+rx /*.sh

VOLUME /u /var/run/docker.sock

ENTRYPOINT ["/launch.sh"]