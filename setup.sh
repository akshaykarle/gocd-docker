#!/bin/bash
set -e

mkdir -p godata/config
cp -f goconfig/cruise-config.xml ./godata/config/cruise-config.xml

mkdir -p godata/plugins/external
if [ ! -f ./godata/plugins/external/docker-elastic-agents-0.7.0.jar ]; then
  curl --location --fail https://github.com/gocd-contrib/docker-elastic-agents/releases/download/v0.7.0/docker-elastic-agents-0.7.0.jar > ./godata/plugins/external/docker-elastic-agents-0.7.0.jar
fi
if [ ! -f ./godata/plugins/external/yaml-config-plugin-0.4.0.jar ]; then
  curl --location --fail https://github.com/tomzo/gocd-yaml-config-plugin/releases/download/0.4.0/yaml-config-plugin-0.4.0.jar > ./godata/plugins/external/yaml-config-plugin-0.4.0.jar
fi
if [ ! -f ./godata/plugins/external/github-oauth-authorization-plugin-1.0.0-1.jar ]; then
  curl --location --fail https://github.com/gocd-contrib/github-oauth-authorization-plugin/releases/download/1.0.0/github-oauth-authorization-plugin-1.0.0-1.jar > ./godata/plugins/external/github-oauth-authorization-plugin-1.0.0-1.jar
fi
