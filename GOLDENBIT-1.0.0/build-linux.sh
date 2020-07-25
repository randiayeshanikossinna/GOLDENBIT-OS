
if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e disk_images/goldenbit.flp ]
then
	echo ">>> Creating new GOLDENBITOS floppy image..."
	mkdosfs -C disk_images/goldenbit.flp 1440 || exit
fi


echo ">>> Assembling bootloader..."

nasm -O0 -w+orphan-labels -f bin -o source/bootload/bootload.bin source/bootload/bootload.asm || exit


echo ">>> Assembling GOLDENBITOS kernel..."

cd source
nasm -O0 -w+orphan-labels -f bin -o kernel.bin kernel.asm || exit
cd ..


echo ">>> Assembling programs..."


dd status=noxfer conv=notrunc if=source/bootload/bootload.bin of=disk_images/goldenbit.flp || exit


echo ">>> Copying GOLDENBITOS kernel and programs..."

rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat disk_images/goldenbit.flp tmp-loop && cp source/kernel.bin tmp-loop/

cp programs/*.bin programs/*.bas programs/sample.pcx tmp-loop

sleep 0.2

echo ">>> Unmounting loopback floppy..."

umount tmp-loop || exit

rm -rf tmp-loop


echo ">>> Creating CD-ROM ISO image..."

rm -f disk_images/goldenbit.iso
mkisofs -quiet -V 'GOLDENBITOS' -input-charset iso8859-1 -o disk_images/goldenbit.iso -b goldenbitos.flp disk_images/ || exit

echo '>>> Done!'

