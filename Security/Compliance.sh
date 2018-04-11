#!/bin/bash
#Working Folder Paths
desktop="${HOME}/Desktop/"
apppath="/Applications"
tmppath="$(mktemp -d /tmp/qinstall_XXX)"
counter=1

#Deletes temp directory if any failures occur
function finish {
rm -rf "$tmppath"
}
trap finish EXIT

echo "Installing ESET Antivirus..."
#ESET Install
tar -xzf EraAgentInstallerMac.tar.gz -C $tmppath
sudo cd $tmpath
sudo bash EraAgentInstaller.sh

echo "Downloading VMware Airwatch"
#Airwatch Install
curl -s -Lo Airwatch-Install.dmg https://awagent.com/Home/DownloadMacOsxAgentApplication
echo "Download Complete"

#Mounts all DMG Files
for f in *.dmg ;
	do hdiutil mount "$f" -nobrowse
	let "counter++"  
done

#Copies pkg files to tmp
sudo rsync -av /Volumes/*/*.pkg $tmppath --exclude /Volumes/Macintosh\ HD
echo "Installing VMware Airwatch"

#Runs each of the installers in /tmp
for f in *.pkg ;
	do sudo installer -verbose -pkg "$f" -target /
done
echo "ejecting all mounted installer volumes"

#Ejects all mounted volumes
for num in $(seq 2 $counter)
do
	diskutil eject /dev/disk$num
done
echo "All Installer DMGs have been ejected"