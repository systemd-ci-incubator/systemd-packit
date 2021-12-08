#!/bin/bash -eux

systemctl --failed --no-legend | tee /failed-services

# Exit with non-zero EC if the /failed-services file is not empty (we have -e set)
[[ ! -s /failed-services ]]

: >/testok
