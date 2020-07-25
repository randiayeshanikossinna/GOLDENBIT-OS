#!/bin/sh

# This script starts the QEMU PC emulator, booting from the
# GOLDENBITOS floppy disk image

qemu-system-i386 -soundhw pcspk -drive format=raw,file=disk_images/goldenbit.flp,index=0,if=floppy
