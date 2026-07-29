#!/bin/bash

source skj conda/env
conda activate cytoscape_env
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export EXTRA_JAVA_OPTS="-Djdk.util.zip.disableZip64ExtraFieldValidation=true"
cytoscape.sh
