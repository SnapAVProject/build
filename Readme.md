# build step
## 1 first build 
... only need to do once 
### 1.1 build buildroot to create cross_compile
`./build.sh rootfs {boardtype} {appversion} {dspversion}`
### 1.2 config host softlink in up folder 
`ln -s ./nuc970_buildroot/output/host ../host `
### 1.3 create image folder to save images
`mkdir ../image`




## 2 nomorl build
### 2.1 set env
`source ./build.sh env`
### 2.2 build uboot
`./build.sh uboot`
### 2.3 build kernel
`./build.sh kernel {boardtype}`
### 2.4 build flag
`./build.sh flag` 
### 2.5 build bootloader.img
`./build.sh boot`
### 2.6 build rootfs
`./build.sh rootfs {boardtype} {appversion} {dspversion}`
### 2.7 build ota upfrade firmware
`./build.sh fw {boardtype} {firmwareversion} {deletedatabase}`
### 2.8 easy build 
`make boardtype={type} appversion={appversion} dspversion=dspversion deletedatabase={true/false}`

