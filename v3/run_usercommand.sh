#!/bin/sh
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /tmp/passwd_template > /tmp/passwd
export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

/home/user/.c9/node/bin/node --expose-gc --always-compact --max-old-space-size=128 /opt/c9sdk/server.js \
    --listen 0.0.0.0 \
    --port 8181 \
    -a $C9_USERNAME:$C9_PASSWORD \
    -w /workspace
