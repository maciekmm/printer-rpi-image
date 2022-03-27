#!/usr/bin/env bash
# Adds printer if it doesn't exist

set -eux

address=$1
name=$2

target_name=$(sed 's/ /_/g' <<<"RAW_$name")

# check if target exists
if lpstat -v "$target_name"; then
    echo "printer already registed" >&2
    exit 0
fi

# register if it doesn't
lpadmin -p "$target_name" \
    -v "$address" \
    -o printer-is-shared=true

echo "printer registered successfully" >&2