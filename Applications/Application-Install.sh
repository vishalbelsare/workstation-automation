#!/bin/bash
#Working Folder Paths
desktop="${HOME}/Desktop/"
apppath="/Applications"
tmppath="$(mktemp -d /tmp/qinstall_XXX)"
counter=1

#Copy download list to temp file, cd into temp dir
cp -r -p ApplicationDownloads.csv $tmppath && cd $tmppath

#Download DMG files from respective sources specified in .csv file ($1=name 2=source)
awk -F"\"*,\"*" '{cmd="curl -s -Lo"$1 " " $2; system(cmd)}' ApplicationDownloads.csv 

#Mounts all DMG Files, and increments a counter to be used in eject sequence
for f in *.dmg ;
	do hdiutil mount "$f" -nobrowse
	let "counter++" 
done

#Copies all .pkg and .zip files to tmppath for processing
sudo rsync -av /Volumes/*/*.pkg $tmppath --exclude /Volumes/Macintosh\ HD
sudo rsync -av /Volumes/*/*.zip $tmppath --exclude /Volumes/Macintosh\ HD

#Unzips all zip files in /tmp
for f in *.zip ;
	do unzip "$f"  
done

#Runs each of the installers in /tmp
for f in *.pkg ;
	do sudo installer -verbose -pkg "$f" -target /
done

#Copies all .app files to /Applications folder from /Volumes and tmppath
sudo rsync -av /Volumes/*/*.app $apppath --exclude /Volumes/Macintosh\ HD
sudo rsync -av $tmppath/*.app $apppath
sudo rsync -av $tmppath/LastPass\ Installer/*.app $apppath

#Open Chrome so that the LastPass installer recognizes it as a browser on the system
open /Applications/Google\ Chrome.app && sleep 5 && open /Applications/LastPass\ Installer.app
echo "All applications have been installed and moved to the /Applications directory"

#Ejects all mounted volumes besides for Macintosh HD (/devdisk0 and /devdisk1)
for num in $(seq 2 $counter)
do
	diskutil eject /dev/disk$num
done
echo "All Installer DMGs have been ejected"

#Deletes temp directory
function finish {
rm -rf "$tmppath"
}
trap finish EXIT
