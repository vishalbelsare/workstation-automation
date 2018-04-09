
tmppath="${HOME}/Desktop/tmp/"

rsync --include '*.app' --include '*.pkg' --exclude "*" --exclude '/Volumes/Macintosh HD' /Volumes/* $tmppath
