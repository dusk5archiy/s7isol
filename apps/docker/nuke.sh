#!/bin/bash

sudo docker system prune -a -f --volumes
sudo docker image prune -a -f
