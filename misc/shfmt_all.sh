#! /usr/bin/env bash

# MIT License
#
# Copyright (c) 2024 Carnegie Mellon University
#
# This file is part of Tartan.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Kasraa: Taken from zsim (https://github.com/s5z/zsim) with some
# modifications: all files under a root path, except don't care files
# (third-party files), are `sed`ed

SCRIPT_DIR=$(dirname -- "$0")
source "${SCRIPT_DIR}/scriptlib.sh"

ROOT=$1
if [[ "$ROOT" == "" ]]; then
    ROOT=$(pwd)
fi

EXTENSIONS=('.sh')

for EXT in "${EXTENSIONS[@]}"; do
    for FILE in $(find "$ROOT" -name *$EXT); do
        IGNORE=$(is_dont_care_file $FILE)
        if [[ "$IGNORE" == 1 ]]; then
            continue
        fi
        shfmt -i 4 -w $FILE
    done
done
