#!/bin/bash
#HomeBrew Install and Configuration V.1

#Installs Xcode Command Line Tools
# (Special Thanks to MokaCoding.com)
echo "Checking Xcode CLI tools"
# Only run if the tools are not installed yet
# To check that try to print the SDK path
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "Xcode CLI tools not found. Installing them..."
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    tail -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" --verbose;
else
  echo "Xcode CLI tools OK"
fi
#Downloads and Installs HomeBrew
echo | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
brew doctor


#Cleanup
sudo rm -rf /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress


