#!/bin/bash

rm -rf ./stackify-java-apm.jar > /dev/null 2>&1
ln -s ./stackify-java-apm-*.jar ./stackify-java-apm.jar
chmod 664 ./*.jar > /dev/null 2>&1

echo "Done"
