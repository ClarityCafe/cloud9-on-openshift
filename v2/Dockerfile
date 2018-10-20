# build layer
FROM node:8-jessie as build
WORKDIR /opt 
RUN apt-get -y install \
        git \
        gcc \
        g++-4.9

RUN git clone https://github.com/pylonide/pylon cloud9 && \
    cd cloud9 && \
    npm install --unsafe-perm && \
    cd .. && \
    git clone https://github.com/exsilium/cloud9-plugin-ungit.git && \
    git clone https://github.com/exsilium/mungit.git && \
    cd mungit && npm install -g grunt-cli && npm install && grunt && \
    cd .. && \
    ln -s /opt/cloud9-plugin-ungit /opt/cloud9/plugins-client/ext.ungit;


# run layer
FROM fedora:27
MAINTAINER Capuccino <chinodesuuu@gmail.com>

COPY --from=build /opt/cloud9 /opt/cloud9
COPY --from=build /opt/cloud9-plugin-ungit /opt/cloud9-plugin-ungit
COPY --from=build /opt/mungit /opt/mungit

ADD run_container.sh /tmp/
RUN chmod +x /tmp/run_container.sh
RUN /tmp/run_container.sh
EXPOSE 8181
ENV HOME "/home/user/"
ADD run_usercommand.sh /tmp/
ADD entrypoint /home/user
RUN chgrp -R 0 /home/user && \
    chmod a+x /home/user/entrypoint && \
    chmod -R g=u /home/user && \
    chmod g=u /etc/passwd;
RUN chmod +x /tmp/run_usercommand.sh
ENV C9_USERNAME ""
ENV C9_PASSWORD ""
VOLUME ["/workspace"]
USER 10001
WORKDIR /opt
ENTRYPOINT ["/home/user/entrypoint"]
CMD ["/tmp/run_usercommand.sh"]

# Labels for Kubernetes, OpenShift and Atomic
LABEL io.k8s.description="A powerful IDE for the cloud under your control! C9 SDK based on CentOS, Fedora or Ubuntu" \
      io.k8s.display-name="Cloud9 IDE" \
      io.openshift.expose-services="8181:http" \
      io.openshift.tags="ide,development" \
      io.projectatomic.nulecule.environment.optional="USERNAME, PASSWORD" \
      io.projectatomic.nulecule.volume.data="/workspace,1Gi"
