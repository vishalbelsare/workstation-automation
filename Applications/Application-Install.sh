#!/bin/bash
#Working Folder Paths
desktop="${HOME}/Desktop/"
tmppath="${HOME}/Desktop/tmp/"
apppath="/Applications"

#Create temp directory to download .dmg files to
mkdir $tmppath
tar -xzf EraAgentInstallerMac.tar.gz -C $tmppath
cp -r ApplicationDownloads.csv $tmppath
cd $tmppath

#Download DMG files from respective sources
awk -F"\"*,\"*" '{cmd="curl -s -Lo"$1 " " $2; system(cmd)}' ApplicationDownloads.csv 

#Mounts all DMG Files
for f in *.dmg ;
	do hdiutil mount "$f" -nobrowse 
done

#Copies .App files directly into Applications folder, and .pkg files to tmp folder for processing [---Want to refactor this with a loop]
cp -r /Volumes/Google\ Chrome/Google\ Chrome.app $apppath
cp -r /Volumes/Slack.app/Slack.app $apppath
cp -r /Volumes/Sublime\ Text/Sublime\ Text.app $apppath
cp -r /Volumes/Emacs/Emacs.app $apppath
cp -r /Volumes/Dropbox\ Installer/Dropbox.app $apppath
echo "Chrome, Slack, and Sublime Text have been moved to your Applications folder"
cp -r /Volumes/VirtualBox/VirtualBox.pkg $tmppath
cp -r /Volumes/AirwatchAgent/VMware\ AirWatch\ Agent.pkg $tmppath

#Unzips all zip files in /tmp
for f in *.zip ;
	do unzip "$f"  
done

#Runs each of the installers in /tmp
cd $tmppath
for f in *.pkg ;
	do sudo installer -verbose -pkg "$f" -target /
done
#Installs ESET Antivirus
bash EraAgentInstaller.sh
#Copies LastPass folder to Desktop and runs installer
cd $tmppath
cp -r LastPass\ Installer $desktop
cd $desktop
#Open Chrome so that the LastPass installer recognizes it as a browser on the system
open /Applications/Google\ Chrome.app
sleep 5
open LastPass\ Installer/LastPass\ Installer.app 

echo "All applications have been installed and moved to the /Applications directory"
echo "Opening Airwatch to continue the enrollment process"
open /Applications/VMware\ Airwatch\ Agent.app

#Ejects all mounted volumes
for num in {2..10}
do
	diskutil eject /dev/disk$num
done
echo "All Installer DMGs have been ejected"

#Deletes /tmp
rm -rf $tmppath




