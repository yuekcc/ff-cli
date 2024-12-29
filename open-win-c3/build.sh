#!/bin/bash

set -ex

c3c compile -O3 -g0 -l shell32 -o open-win main.c3
