#!/bin/bash

set -euo pipefail

cd /home/adevuser
git clone https://github.com/dusk5archiy/s7isol.git
cd s7isol
bash install.sh /home/adevuser
