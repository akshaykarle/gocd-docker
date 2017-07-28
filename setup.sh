#!/bin/bash
set -e

mkdir -p godata/plugins/external
curl --location --fail https://github.com/gocd-contrib/docker-elastic-agents/releases/download/v0.7.0/docker-elastic-agents-0.7.0.jar > ./godata/plugins/external/docker-elastic-agents-0.7.0.jar
mkdir -p godata/config
cp goconfig/cruise-config.xml ./godata/config/cruise-config.xml
