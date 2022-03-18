#!/bin/bash

cd /retropilot-server/

node -r esm server.js 2>&1 &
node -r esm worker.js 2>&1 &

sleep infinity
