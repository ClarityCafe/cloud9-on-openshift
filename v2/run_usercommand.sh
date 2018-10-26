#!/bin/bash

if [ ! -z "$PLN_PASSWORD" ] && [ ! -z "$PLN_USERNAME" ]; then
   echo "Starting Cloud9..."
   node cloud9/server.js -w /workspace -l 0.0.0.0 -p 8181 --username $PLN_USERNAME --password $PLN_PASSWORD;
else
   echo "[warn] Starting Cloud9 Without Authorization is highly discouraged. Set them from the PLN_USERNAME and PLN_PASSWORD variables!"
   node cloud9/server.js -w /workspace -l 0.0.0.0 -p 8181;
fi
