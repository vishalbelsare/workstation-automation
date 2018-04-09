#!/bin/bash
awk -F"\"*,\"*" '{gsub(/\r/,"",$1); cmd="cask brew install " $1; system(cmd)}' Brew_Dependency_Input.csv 
awk -F"\"*,\"*" '{gsub(/\r/,"",$1); cmd="brew cask install " $1; system(cmd)}' Cask_Dependency_Input.csv 
