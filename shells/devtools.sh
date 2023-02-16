#!/bin/sh

# Cocoapods
echo "Cocoapods をインストールします"
brew install cocoapods
pod setup

# Carthage
echo "Carthage をインストールします"
brew install carthage