# Android magisk customize.sh @tryigitx

# Gather Information
SOC=$(getprop ro.soc.model)
MODVER=$(grep_prop version $MODPATH/module.prop)
MODVERCODE=$(grep_prop versionCode $MODPATH/module.prop)

# Display Info
ui_print " "
ui_print " Version: $MODVER"
ui_print " Website: tryigit.dev/snapdragon"
ui_print " Help and Donate: t.me/cleverestech"
ui_print " "
ui_print " - Rom Check..."

# Rom Check
if [ "$(getprop ro.build.host)" != "xiaomi.eu" ]; then
    echo " - Success Variant 1 🌍"
else
    echo " "
    echo "❗Very bad ROM (risky)"
    echo " "
fi

# First Use Check
if [ "$(getprop pm.dexopt.first-use)" != "false" ]; then
    echo " - Success Variant 2 🌍"
else
    echo " "
    echo "! Bad ROM"
    echo " "
fi

ui_print " - Android Version Check..."
if [ $(getprop ro.system.build.version.sdk) -lt 31 ]; then
    echo "! Unsupported Android version detected, please upgrade."
    abort
else
    echo " - Success 🌍"
fi
echo " "

# Pause before setting permissions
sleep 1


# Apply permissions
set_perm_recursive $MODPATH/system/vendor 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/etc/sphal_libraries.txt 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/lib* 0 0 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH  0  0  0755  0644
set_perm_recursive $MODPATH/system/vendor/lib/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libEGL_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libGLESv2_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libadreno_app_profiles.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libq3dtools_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libllvm-qgl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libllvm-qgl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libllvm-glnext.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libllvm-qcom.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libadreno_utils.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libadreno_utils.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/hw/vulkan.adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/egl/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libVkLayer_ADRENO_qprofiler.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libVkLayer_ADRENO_qprofiler.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libEGL_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libGLESv2_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libadreno_app_profiles.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libq3dtools_adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/hw/vulkan.adreno.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libllvm-qgl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libllvm-glnext.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libllvm-qcom.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/egl/ 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/lib/egl/libEGL_adreno.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib64/egl/libEGL_adreno.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib/egl/libVkLayer_ADRENO_qprofiler.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib64/egl/libVkLayer_ADRENO_qprofiler.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib64/libEGL.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib64/libGLESv1_CM.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib64/libGLESv2.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib64/libGLESv3.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib64/libvulkan.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib/libEGL.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib/libGLESv1_CM.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib/libGLESv2.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib/libGLESv3.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/lib/libvulkan.so 0 0 0755 0644 u:object_r:system_lib_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libdmabufheap.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib/libdmabufheap.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libCB.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libgsl.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0
set_perm_recursive $MODPATH/system/vendor/lib64/libadreno_utils.so 0 0 0755 0644 u:object_r:same_process_hal_file:s0

# Set specific permissions
chmod 644 /system/vendor/firmware/a650_sqe.fw
sleep 1

ui_print " - Success 🌍"
ui_print " "
ui_print " - Final step for GPU Cache Cleaner by tryigitx"
ui_print " - Please wait..."

# GPU Cache Cleaner @tryigitx
gpu_cache_cleaner() {
    find "$1" -type f -name '*shader*' -exec rm -f {} \;
    if [ -e "$1" ]; then
        echo "Folder $1 still exists ❗"
    else
        echo " - $1 cleared 🧭"
    fi
}

gpu_cache_cleaner "/data"
gpu_cache_cleaner "/data/user_de/*shader_cache*/code_cache"

ui_print " "
ui_print " - Please reboot 🎉"
ui_print " "
