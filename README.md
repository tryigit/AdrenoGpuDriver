# Qualcomm Drivers
The aim of this github project is to The goal of this github project is to create a template that everyone can use. Unfortunately, Oems and Qualcomm are very bad at providing drivers for the Adreno GPU. Currently focused on magisk, kernelsu and other root projects may be added in the future. First of all, a/b ota update support is expected. You can create your own modules using template.

### Two solutions for bootloop and similar problems
+ **Recovery:** Safe Mode
+ **Twrp:** `/data/adb/modules` delete


## Community Created Drivers
https://tryigit.dev/snapdragon-drivers

To support community drivers, send your own driver modules to this telegram group. I stopped working for the community because I don't like the community.

### Telegram:
https://t.me/cleverestech

## Drivers Customized By Yigit
https://tryigit.dev/vip-drivers/


## Driver Files
> [!IMPORTANT]
> Support the project to update it

### Opengl Driver
```
/lib*/egl/eglSubDriverAndroid.so
/lib*/egl/libEGL_adreno.so
/lib*/egl/libGLESv1_CM_adreno.so
/lib*/egl/libGLESv2_adreno.so
/lib*/egl/libq3dtools_adreno.so
/lib*/egl/libq3dtools_esx.so
/lib*/egl/some additional files (according to gpu)
```

### Vulkan Driver
```
/lib*/hw/vulkan.adreno.so
/lib*/hw/some additional files (according to gpu)
```

### Opencl Driver
```
/lib*/libCB.so
/lib*/some additional files (according to gpu)
```

### Required Files
```
/lib*/libadreno_utils.so
/lib*/libgpudataproducer.so
/lib*/libllvm-glnext.so
/lib*/libllvm-qcom.so
/lib*/libllvm-qgl.so
/lib*/libgsl.so
/lib*/firmware/a*_sqe.fw (according to gpu)
/lib*/some additional files (according to gpu)
```

## Android Native Feature
Did you know that if you have a computer, you can change the drivers for games and apps separately from the android system?

+ https://gpuinspector.dev/
+ https://github.com/google/agi

## Driver Update App
> [!WARNING]
> This feature is not supported by older devices.

There are very few people skilled enough to do this, but you can modify the system gpu driver implementation by editing some prop code! So in the future it is possible to make a Qualcomm independent gpu driver implementation.
```
ro.gfx.driver.0=com.xiaomi.ugd
ro.gfx.driver.1=com.qualcomm.qti.gpudrivers.kalama.api33
```
## Edit Gpu Driver
You will need to learn how to use the **Adreno Profile Tools**. You can also download it from the official Qualcomm website. In general, this template is for drivers extracted from the rom dump.

## Known Issues
- [x] Kernelsu compatibility
- [ ] Magiskhide map conflict (improved with better permission structure and properties)
> [!NOTE]
> The prop code `ro.zygote.disable_gl_preload=true` helps fix the magiskhide EGL issue. Additional compatibility properties have been added to `system.prop`.
