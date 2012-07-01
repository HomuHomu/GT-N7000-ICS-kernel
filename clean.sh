#!/bin/sh

echo "cleaning..."
make clean
make mrproper
git clean -f
echo "cleaning done!"
