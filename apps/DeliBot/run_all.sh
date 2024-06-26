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

BINARY="delibot_baseline.out"
INPUT_MAP_DIRECTORY="./input-maps"
INPUT_MEAS_DIRECTORY="./input-measurements"
OUTPUT_DIRECTORY="./output-logs"

if [[ ! -f $BINARY || ! -d $INPUT_MAP_DIRECTORY || ! -d $INPUT_MEAS_DIRECTORY ]]; then
    echo "Missing required files!"
    echo "Binary: $BINARY ?"
    echo "Input maps: $INPUT_MAP_DIRECTORY ?"
    echo "Input measurements: $INPUT_MEAS_DIRECTORY ?"
    exit 1
fi

execute() {
    local MAP_FILE=$1
    local MEAS_FILE=$2
    local PARTICLES=$3

    local MAP_NAME=$(basename "$INPUT_MAP_DIRECTORY" .dat)
    local MEAS_NAME=$(basename "$INPUT_MEAS_DIRECTORY" .txt)

    mkdir -p "$OUTPUT_DIRECTORY"
    local OUTPUT_FILE="$OUTPUT_DIRECTORY/"
    OUTPUT_FILE="${OUTPUT_FILE}map-${MAP_NAME}_"
    OUTPUT_FILE="${OUTPUT_FILE}meas-${MEAS_NAME}_"
    OUTPUT_FILE="${OUTPUT_FILE}p-${PARTICLES}"
    OUTPUT_FILE="${OUTPUT_FILE}.txt"

    local ARGUMENTS=""
    ARGUMENTS="$ARGUMENTS--map=$MAP_FILE "
    ARGUMENTS="$ARGUMENTS--measurements=$MEAS_FILE "
    ARGUMENTS="$ARGUMENTS--particles=$PARTICLES "
    ARGUMENTS="$ARGUMENTS--output=$OUTPUT_FILE "

    echo "Running ./${BINARY} ${ARGUMENTS}"
    ./$BINARY $ARGUMENTS
    if [[ $? != 0 ]]; then
        echo "Error in running ./${BINARY} ${ARGUMENTS}"
    fi

    echo "--------------------------------------"
}

ALL_PARTICLES=(10 100)

for MAP_FILE in "$INPUT_MAP_DIRECTORY"/*; do
    for MEAS_FILE in "$INPUT_MEAS_DIRECTORY"/*; do
        for PARTICLES in "${ALL_PARTICLES[@]}"; do
            execute "$MAP_FILE" "$MEAS_FILE" "$PARTICLES" &
        done
    done
done

wait

echo "**************************************"

exit 0
