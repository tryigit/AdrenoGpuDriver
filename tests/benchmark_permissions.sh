#!/bin/bash

# Benchmark script for permission setting in customize.sh

MODPATH="./benchmark_modpath"
rm -rf "$MODPATH"
mkdir -p "$MODPATH"

# Create a large directory structure
# 1000 files in system/lib (special)
# 1000 files in system/app (normal)
# 100 files in root
echo "Generating test files..."
mkdir -p "$MODPATH/system/lib"
mkdir -p "$MODPATH/system/app"
mkdir -p "$MODPATH/system/vendor/firmware"

for i in $(seq 1 2000); do
    touch "$MODPATH/system/lib/lib$i.so"
    touch "$MODPATH/system/app/app$i.apk"
    touch "$MODPATH/system/vendor/firmware/fw$i.bin"
done
for i in $(seq 1 100); do
    touch "$MODPATH/file$i"
done

# Mock functions
ui_print() { :; }
abort() { exit 1; }
getprop() { echo "benchmark"; }

# Mock set_perm_recursive to simulate work
# In real Magisk, this calls chown, chmod, chcon.
# We will simulate the traversal and syscalls using find and stats.
set_perm_recursive() {
    local dir="$1"
    # We want to measure the cost of traversal and execution.
    # We use find to traverse.
    # Real set_perm_recursive calls chown, chmod, chcon.
    find "$dir" -exec true {} + -exec true {} + -exec true {} +
}

# Source the original script logic (we will manually run the relevant part)
# The relevant part is from line 58 onwards.

measure_original() {
    local start_time=$(date +%s%N)

    # Original logic
    set_perm_recursive $MODPATH 0 0 0755 0644

    if [ -d "$MODPATH/system/lib" ]; then
        set_perm_recursive $MODPATH/system/lib 0 0 0755 0644 u:object_r:system_lib_file:s0
    fi
    if [ -d "$MODPATH/system/lib64" ]; then
        set_perm_recursive $MODPATH/system/lib64 0 0 0755 0644 u:object_r:system_lib_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/firmware" ]; then
        set_perm_recursive $MODPATH/system/vendor/firmware 0 0 0755 0644 u:object_r:vendor_firmware_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/etc" ]; then
        set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0644 u:object_r:vendor_configs_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/lib" ]; then
        set_perm_recursive $MODPATH/system/vendor/lib 0 0 0755 0644 u:object_r:same_process_hal_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/lib64" ]; then
        set_perm_recursive $MODPATH/system/vendor/lib64 0 0 0755 0644 u:object_r:same_process_hal_file:s0
    fi

    local end_time=$(date +%s%N)
    echo "$(( (end_time - start_time) / 1000000 ))"
}

measure_optimized() {
    local start_time=$(date +%s%N)

    # Optimized logic (Proposed)
    # 1. Skip the global set_perm_recursive
    # 2. Use find with prune for default permissions

    # Define directories to skip (because they are handled later)
    # We construct the find command to prune these.

    find "$MODPATH" \
        \( \
           -path "$MODPATH/system/lib" -o \
           -path "$MODPATH/system/lib64" -o \
           -path "$MODPATH/system/vendor/firmware" -o \
           -path "$MODPATH/system/vendor/etc" -o \
           -path "$MODPATH/system/vendor/lib" -o \
           -path "$MODPATH/system/vendor/lib64" \
        \) -prune -o \
        -type d -exec true {} + -exec true {} + -exec true {} + -o \
        -type f -exec true {} + -exec true {} + -exec true {} +

    # Specific calls
    if [ -d "$MODPATH/system/lib" ]; then
        set_perm_recursive $MODPATH/system/lib 0 0 0755 0644 u:object_r:system_lib_file:s0
    fi
    if [ -d "$MODPATH/system/lib64" ]; then
        set_perm_recursive $MODPATH/system/lib64 0 0 0755 0644 u:object_r:system_lib_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/firmware" ]; then
        set_perm_recursive $MODPATH/system/vendor/firmware 0 0 0755 0644 u:object_r:vendor_firmware_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/etc" ]; then
        set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0644 u:object_r:vendor_configs_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/lib" ]; then
        set_perm_recursive $MODPATH/system/vendor/lib 0 0 0755 0644 u:object_r:same_process_hal_file:s0
    fi
    if [ -d "$MODPATH/system/vendor/lib64" ]; then
        set_perm_recursive $MODPATH/system/vendor/lib64 0 0 0755 0644 u:object_r:same_process_hal_file:s0
    fi

    local end_time=$(date +%s%N)
    echo "$(( (end_time - start_time) / 1000000 ))"
}

echo "Running benchmark..."
ORIG_TIME=$(measure_original)
echo "Original time: ${ORIG_TIME}ms"

OPT_TIME=$(measure_optimized)
echo "Optimized time: ${OPT_TIME}ms"

rm -rf "$MODPATH"
