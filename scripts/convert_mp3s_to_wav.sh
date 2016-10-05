echo "This script has dependencies: ['sox', 'libsox-fmt-mp3']."
echo "If they aren't installed, stop the script and install them before proceeding."

echo "Enter relative folder path which contains  mp3 files (wav files will be created here)"
read path

cd $path && find -iname "*.mp3" -exec sox -V3 {} {}.SOX-CONVERTED.wav \;
