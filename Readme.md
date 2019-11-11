# build step
## first build 
... only need to do once 
### build buildroot to create cross_compile
`./build.sh rootfs {boardtype} {appversion} {dspversion}`
### config host softlink in up folder 
`ln -s ../nuc970_buildroot/output/host ../host `
### create image folder to save images
`mkdir ../image`


## nomorl build
### set env
`source ./build.sh env`
### build uboot
`./build.sh uboot`
### build kernel
`./build.sh kernel {boardtype}`
### build flag
`./build.sh flag` 
### build bootloader.img
`./build.sh boot`
### build rootfs
`./build.sh rootfs {boardtype} {appversion} {dspversion}`
### build ota upfrade firmware
`./build.sh fw {boardtype} {firmwareversion} {deletedatabase}`
### easy build 
`make boardtype={type} appversion={appversion} dspversion=dspversion deletedatabase={true/false}`

