#!/usr/bin/env bash
#
# This script assumes a linux environment

echo "*** nuTensor.firefox: Creating web store package"
echo "*** nuTensor.firefox: Copying files"

BLDIR=dist/build
DES="$BLDIR"/nuTensor.firefox
rm -rf $DES
mkdir -p $DES

bash ./tools/make-assets.sh $DES

cp -R ./src/*                               $DES/
cp    platform/chromium/*.js                $DES/js/
cp -R platform/chromium/img/*               $DES/img/
cp    LICENSE.txt                           $DES/

cp    platform/firefox/*.js                 $DES/js/
cp    platform/firefox/manifest.json        $DES/

echo "*** nuTensor.firefox: Generating meta..."
python3 tools/make-firefox-meta.py          $DES/

if [ "$1" = all ]; then
    echo "*** nuTensor.firefox: Creating package..."
    pushd $DES > /dev/null
    zip ../$(basename $DES).xpi -qr *
    popd > /dev/null
elif [ -n "$1" ]; then
    echo "*** nuTensor.firefox: Creating versioned package..."
    pushd $DES > /dev/null
    zip ../$(basename $DES).xpi -qr *
    popd > /dev/null
    mv "$BLDIR"/nuTensor.firefox.xpi "$BLDIR"/nuTensor"$1".firefox.xpi
fi

echo "*** nuTensor.firefox: Package done."
