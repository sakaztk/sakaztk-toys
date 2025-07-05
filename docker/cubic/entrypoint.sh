#!/bin/bash

if [ -d "/home/cubic/cubic" ]; then
  sudo chown -R cubic:cubic /home/cubic/cubic
fi

exec "$@"
