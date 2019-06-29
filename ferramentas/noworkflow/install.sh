#!/bin/bash

# clone repo
git clone -b 2.0-alpha --single-branch "https://github.com/gems-uff/noworkflow.git"
cd "noworkflow/capture" && python3 setup.py install

# (re)check python depedencies
pip3 install matplotlib anaconda numpy flask graphviz ipykernel
pip3 install -r requirements.txt
