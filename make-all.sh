#!/bin/bash

set -eu

echo 'Building docs...'
echo
./make-docs.sh
echo
echo 'Building ISO...'
echo
./make-iso.sh
