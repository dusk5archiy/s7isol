#!/bin/bash

sudo apt install openjdk-17-jdk openjfx

source skj conda/env
conda create -n cytoscape_env
conda activate cytoscape_env

conda install -c bioconda cytoscape
conda install -c conda-forge javafx
