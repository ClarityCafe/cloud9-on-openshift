# run layer
FROM centos:7 as run

# Install bare minimum things for our stack. We don't need anything flashy
# We will let the user install their own things. However, PowerTools is enabled for good measure.

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y \
        dnf-plugins-core \
        sudo \
        wget \
        curl \
        python38 \
        python27 \
        python2-dnf \
        ansible \
        nodejs \
        clang \
        git \
        cmake \
        && \
    yum group install "Development tools" -y

# Create the user
RUN adduser user -u 1000 -g 0 -r -m -d /home/user/ -c "Default Application User" -l && \
    echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user;

# Add workspace and set permissions
RUN mkdir -p /workspace && \
    chown -R user:root /workspace && \
    chmod -R g+rw /workspace;

WORKDIR /opt

USER 1000

RUN curl -sSL https://github.com/gbraad/ansible-playbooks/raw/master/playbooks/install-c9sdk.yml -o /tmp/install.yml && \
    ansible-playbook /tmp/install.yml && \
    rm -rf /tmp/install.yml;

EXPOSE 8181

ENTRYPOINT ["/home/user/.c9/node/bin/node"]
CMD ["/opt/c9sdk/server.js", "-w /workspace", "-a $C9_USERNAME:$C9_PASSWORD", "--port 8181", "--listen 0.0.0.0"]
