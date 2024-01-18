# Qualcomm Snapdragon Drivers
The aim of this github project is to create a template that everyone can use. Unfortunately Oems and Qualcomm are very bad at providing drivers for the Adreno gpu.
Currently magisk focused. kernelsu and other root projects may be added in the future. First of all, a/b ota update support is expected.

## Community Created Drivers
(https://tryigit.dev/snapdragon-drivers)

To support community drivers, send your own driver modules on this telegram group.

### Telegram:
(https://t.me/+9iW4KfPrc_owZTMx)

## Drivers Customized By Yigit
(https://tryigit.dev/vip-drivers/)


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

### Required files
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
