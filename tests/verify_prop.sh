#!/bin/bash

PROP_FILE="Magisk Template/system.prop"

echo "Checking properties in $PROP_FILE..."

if [ ! -f "$PROP_FILE" ]; then
    echo "FAIL: $PROP_FILE not found"
    exit 1
fi

REQUIRED_PROPS=(
    "ro.zygote.disable_gl_preload=true"
    "ro.hardware.vulkan=adreno"
    "ro.hardware.egl=adreno"
)

RET=0
for prop in "${REQUIRED_PROPS[@]}"; do
    if grep -Fq "$prop" "$PROP_FILE"; then
        echo "PASS: Found $prop"
    else
        echo "FAIL: Missing $prop"
        RET=1
    fi
done

exit $RET
