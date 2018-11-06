#!/bin/bash

if [ ! -z "$PLN_PASSWORD" ] && [ ! -z "$PLN_USERNAME" ]; then
   echo "Starting Cloud9..."
   $(command -v node) --expose-gc --always-compact --max-old-space-size=128 cloud9/server.js -w /workspace -l 0.0.0.0 -p 8181 --username $PLN_USERNAME --password $PLN_PASSWORD;
else
   echo "[warn] Starting Cloud9 Without Authorization is highly discouraged. Set them from the PLN_USERNAME and PLN_PASSWORD variables!"
   $(command -v node) --expose-gc --always-compact --max-old-space-size=128 cloud9/server.js -w /workspace -l 0.0.0.0 -p 8181;
fi
