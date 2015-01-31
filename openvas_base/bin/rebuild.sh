#!/bin/bash

while true; do
    echo "Waiting..."
    sleep 5

    if [ -z "$(ps aux | grep ETA | grep -v grep)" ]; then
        echo "Ready to start openvasmd rebuild..."
        openvasmd --rebuild&
        disown $!
        break
    fi
done
