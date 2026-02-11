# Android magisk customize.sh @tryigitx

# Gather Information
SOC=$(getprop ro.soc.model)

# Efficiently read version and versionCode from module.prop
MODVER=""
MODVERCODE=""
while IFS='=' read -r key value || [ -n "$key" ]; do
    case "$key" in
        version) [ -z "$MODVER" ] && MODVER="$value" ;;
        versionCode) [ -z "$MODVERCODE" ] && MODVERCODE="$value" ;;
    esac
    [ -n "$MODVER" ] && [ -n "$MODVERCODE" ] && break
done < "$MODPATH/module.prop"

# Display Info
ui_print " "
ui_print " Version: $MODVER"
ui_print " Website: tryigit.dev/snapdragon"
ui_print " Help and Donate: t.me/cleverestech"
ui_print " "
ui_print " - Rom Check..."

# Rom Check
if [ "$(getprop ro.build.host)" != "xiaomi.eu" ]; then
    ui_print " - Success Variant 1 🌍"
else
    ui_print " "
    ui_print "❗Very bad ROM (risky)"
    ui_print " "
fi

# First Use Check
if [ "$(getprop pm.dexopt.first-use)" != "false" ]; then
    ui_print " - Success Variant 2 🌍"
else
    ui_print " "
    ui_print "! Bad ROM"
    ui_print " "
fi

ui_print " - Android Version Check..."
if [ $(getprop ro.system.build.version.sdk) -lt 31 ]; then
    ui_print "! Unsupported Android version detected, please upgrade."
    abort
else
    ui_print " - Success 🌍"
fi
ui_print " "

# Pause before setting permissions
sleep 1

ui_print " - Setting permissions..."

# Apply base module permissions
set_perm_recursive $MODPATH 0 0 0755 0644

# Apply permissions for system lib directories (recursive)
# SELinux context: u:object_r:system_lib_file:s0 for system libraries
if [ -d "$MODPATH/system/lib" ]; then
    set_perm_recursive $MODPATH/system/lib 0 0 0755 0644 u:object_r:system_lib_file:s0
fi

if [ -d "$MODPATH/system/lib64" ]; then
    set_perm_recursive $MODPATH/system/lib64 0 0 0755 0644 u:object_r:system_lib_file:s0
fi

# Apply permissions for vendor firmware (specific context first)
if [ -d "$MODPATH/system/vendor/firmware" ]; then
    set_perm_recursive $MODPATH/system/vendor/firmware 0 0 0755 0644 u:object_r:vendor_firmware_file:s0
fi

# Apply permissions for vendor etc files (specific context)
if [ -d "$MODPATH/system/vendor/etc" ]; then
    set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0644 u:object_r:vendor_configs_file:s0
fi

# Apply permissions for vendor lib directories (GPU libraries)
# SELinux context: u:object_r:same_process_hal_file:s0 for vendor GPU libraries
if [ -d "$MODPATH/system/vendor/lib" ]; then
    set_perm_recursive $MODPATH/system/vendor/lib 0 0 0755 0644 u:object_r:same_process_hal_file:s0
fi

if [ -d "$MODPATH/system/vendor/lib64" ]; then
    set_perm_recursive $MODPATH/system/vendor/lib64 0 0 0755 0644 u:object_r:same_process_hal_file:s0
fi

ui_print " - Success 🌍"
ui_print " "
ui_print " - Final step for GPU Cache Cleaner by tryigitx"
ui_print " - Please wait..."

# GPU Cache Cleaner @tryigitx
gpu_cache_cleaner() {
    local target_path="$1"
    if [ -d "$target_path" ]; then
        # Remove shader cache directories and GPU cache files
        find "$target_path" \( -type d -name '*shader_cache*' -prune -exec rm -rf {} \; \) -o \
            \( -type f \( -name '*shader*' -o -name '*gpu_cache*' \) -exec rm -f {} \; \) 2>/dev/null
        ui_print " - $target_path cleared 🧭"
    fi
}

gpu_cache_cleaner "/data/data"
gpu_cache_cleaner "/data/user_de"
gpu_cache_cleaner "/data/user"

ui_print " "
ui_print " - Please reboot 🎉"
ui_print " "
