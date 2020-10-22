# build layer
FROM node:10-stretch as build
WORKDIR /opt

RUN git clone https://github.com/c9/core.git cloud9

# run layer
FROM centos as run

COPY --from=build /opt /opt

# Install bare minimum things for our stack. We don't need anything flashy
# We will let the user install their own things.
# We will have PowerTools enabled just for good measure.

RUN yum update -y && \
    yum install -y \
        dnf-plugins-core \
        sudo \
        python38 \
        python27 \
        nodejs \
        clang \
        git \
        cmake \
        tmux \
        && \
    dnf config-manager --set-enabled PowerTools && \
    dnf group install "Development tools" -y && \
    yum install -y glibc-static;

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
ADD run_v3.sh .

USER 1000

# Final step, installing SDK in the user dir.
RUN bash /opt/cloud9/scripts/install-sdk.sh

EXPOSE 8181
CMD ["/opt/run_v2.sh"]
