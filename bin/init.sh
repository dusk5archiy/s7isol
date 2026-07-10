#!/bin/bash

# ------------------------------------------------------------------------------

if [[ ! -f ".pre.env" ]]; then
  cp example.pre.env .pre.env
fi

if [[ ! -f ".post.env" ]]; then
  cp example.post.env .post.env
fi
