# build layer
FROM node:10-stretch as build
WORKDIR /opt

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
FROM centos as run

COPY --from=build /opt /opt

# Install bare minimum things for our stack. We don't need anything flashy
# We will let the user install their own things. However, PowerTools is enabled for good measure.

RUN yum update -y && \
    yum install -y \
        dnf-plugins-core \
        sudo \
        python38 \
        nodejs \
        clang \
        git \
        cmake \
        && \
    dnf config-manager --set-enabled PowerTools && \
    dnf group install "Development tools" -y;

# Create the user
RUN adduser user -u 1000 -g 0 -r -m -d /home/user/ -c "Default Application User" -l && \
    echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user;

# Add workspace and set permissions
RUN mkdir -p /workspace && \
    chown -R user:root /workspace && \
    chmod -R g+rw /workspace && \
    chown -R 1000:0 /opt/cloud9;

WORKDIR /opt
ADD run_v2.sh .

USER 1000
EXPOSE 8181
CMD ["/opt/run_v2.sh"]