#!/bin/bash

git archive --format=zip --output="../z-$(basename "$PWD").zip" HEAD
