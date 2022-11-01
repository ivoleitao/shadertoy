#!/usr/bin/env bash

if [ -d "build/dist" ]; then
  rm -rf build/dist
fi

if [ -d "build/debug_info" ]; then
  rm -rf build/debug_info
fi

mkdir -p build/dist build/debug_info
cp -r info.plist assets/* LICENSE README.md demo.gif build/dist

dart compile exe bin/shadertoy_alfred.dart -o build/dist/st -S build/debug_info/st