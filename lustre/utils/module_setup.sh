#!/bin/sh

MDIR=/lib/modules/`uname -r`/lustre

KVER=24
EXT=o
FSFLT=fsfilt_ext3
MODFILE="/etc/modules.conf"
if [ `uname -r | cut -c 3` -eq 6 ]; then
    KVER=26
    EXT=ko
    FSFLT=fsfilt_ldiskfs
    MODFILE="/etc/modprobe.conf"
fi

echo "Copying modules from local build dir to "$MDIR

mkdir -p $MDIR

cp ../../portals/libcfs/libcfs.$EXT $MDIR
cp ../../portals/portals/portals.$EXT $MDIR
cp ../../portals/knals/socknal/ksocknal.$EXT $MDIR
cp ../lvfs/lvfs.$EXT $MDIR
cp ../obdclass/obdclass.$EXT $MDIR
cp ../ptlrpc/ptlrpc.$EXT $MDIR
cp ../mdc/mdc.$EXT $MDIR
cp ../osc/osc.$EXT $MDIR
cp ../lov/lov.$EXT $MDIR
cp ../mds/mds.$EXT $MDIR
cp ../lvfs/$FSFLT.$EXT $MDIR
[ $KVER == "26" ] && cp ../ldiskfs/ldiskfs.$EXT $MDIR
cp ../ost/ost.$EXT $MDIR
cp ../obdfilter/obdfilter.$EXT $MDIR
cp ../llite/llite.$EXT $MDIR

# prevent warnings on my uml
rm -f /lib/modules/`uname -r`/modules.*
echo "Depmod"
depmod -a -e

echo "Copying mount from local build dir to "$MDIR
cp ../utils/mount.lustre /sbin/.

[ -e $MODFILE ] || touch $MODFILE
if [ `grep -c lustre $MODFILE` -eq 0 ]; then
    echo Modifying $MODFILE
    echo "# Lustre modules added by $0" >> $MODFILE
    if [ $KVER -eq 24 ]; then
	echo alias lustre null >> $MODFILE
	echo above lustre llite osc mdc >> $MODFILE
	echo above mds llite osc $FSFLT >> $MODFILE
	echo alias oss ost >> $MODFILE
	echo above ost llite obdfilter $FSFLT >> $MODFILE
	echo above portals ksocknal >> $MODFILE
    else
	MP="/sbin/modprobe"
	MPI="$MP --ignore-install"
	echo "install kptlrouter $MP portals && $MPI kptlrouter" >> $MODFILE
	echo "install _lustre $MP portals && $MP lvfs && $MP obdclass && $MP ptlrpc" >> $MODFILE
	echo "install obdfilter $MP _lustre && $MP ost && $MP ldiskfs && $MP $FSFLT && $MPI obdfilter" >> $MODFILE
	echo "install oss $MP _lustre && $MP ost && $MPI oss" >> $MODFILE
	echo "install mds $MP _lustre && $MP osc && $MPI mds" >> $MODFILE
	echo "install llite $MP _lustre && $MP osc && $MP mdc && $MPI llite" >> $MODFILE
	echo "alias lustre llite" >> $MODFILE
    fi
    echo "# end Lustre modules" >> $MODFILE
fi

