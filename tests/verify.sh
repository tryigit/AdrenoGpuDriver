#!/bin/bash

# Cleanup trap
cleanup() {
    rm -rf "$MODPATH" "$MOCK_DATA"
}
trap cleanup EXIT

# Mock Magisk environment variables
export MODPATH="./mock_modpath"
mkdir -p "$MODPATH"
cp -r "Magisk Template"/* "$MODPATH/"

# Mock Android filesystem for cache cleaner test
MOCK_DATA="./mock_data"
rm -rf "$MOCK_DATA"
mkdir -p "$MOCK_DATA/user/0/com.example.app/cache/shader_cache"
mkdir -p "$MOCK_DATA/user/0/com.example.app/cache/gpu_cache"
touch "$MOCK_DATA/user/0/com.example.app/cache/shader_cache/some_file"
touch "$MOCK_DATA/user/0/com.example.app/cache/gpu_cache/some_file_named_gpu_cache"
mkdir -p "$MOCK_DATA/data/com.another.app/code_cache"

# Mock functions
ui_print() {
    echo "[UI_PRINT] $@"
}

abort() {
    echo "[ABORT] Script aborted!"
    exit 1
}

set_perm_recursive() {
    echo "[SET_PERM] $@"
}

getprop() {
    case "$1" in
        ro.soc.model) echo "SM8450" ;;
        ro.build.host) echo "xiaomi.eu" ;;
        pm.dexopt.first-use) echo "false" ;;
        ro.system.build.version.sdk) echo "33" ;; # Android 13
        *) echo "" ;;
    esac
}

# Export functions so they are available in subshells if needed (not really needed for source)
export -f ui_print abort set_perm_recursive getprop

# Run the script
echo "Running customize.sh..."
# We source it because that's how Magisk runs it usually, but here we can just execute it if we handle the sourcing
# The script is designed to be sourced by update-binary usually, but standalone execution is fine for testing logic if we provide the environment.
# However, `customize.sh` uses `find` on paths passed to `gpu_cache_cleaner`.
# We need to modify the call to `gpu_cache_cleaner` in the script or mock the paths it uses.
# The script calls: `gpu_cache_cleaner "/data/data" "/data/user_de" "/data/user"`
# We can't easily change the arguments in the sourced script without editing it.
# So we will create a wrapper or use `sed` to replace the paths with our mock paths for testing.

# Replace paths in customize.sh for testing
sed -i "s|/data/data|\"$MOCK_DATA/data\"|g" "$MODPATH/customize.sh"
sed -i "s|/data/user_de|\"$MOCK_DATA/user_de\"|g" "$MODPATH/customize.sh"
sed -i "s|/data/user|\"$MOCK_DATA/user\"|g" "$MODPATH/customize.sh"

# Source the script
. "$MODPATH/customize.sh"

# Verify deletions
RET=0
if [ -d "$MOCK_DATA/user/0/com.example.app/cache/shader_cache" ]; then
    echo "FAIL: shader_cache directory was not removed"
    RET=1
else
    echo "PASS: shader_cache directory removed"
fi

if [ -d "$MOCK_DATA/user/0/com.example.app/cache/gpu_cache" ]; then
    echo "FAIL: gpu_cache directory was not removed"
    RET=1
else
    echo "PASS: gpu_cache directory removed"
fi

exit $RET

# Clean up handled by trap or earlier
