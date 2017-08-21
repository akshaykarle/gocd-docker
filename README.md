# GoCD setup with docker
Launch a GoCD server agent setup with a sample pipeline.

## Getting started
* Install `docker` and `docker-compose`
* Run `./setup.sh`
* Run `docker-compose up -d`
* You should now be able to access http://localhost:8153/go/
* You need to login for the first time using `gomatic` user

## Configure the Elastic agent plugin
* Navigate to the go plugins and edit the elastic agent: http://localhost:8153/go/admin/plugins
* Go Server URL: https://docker.for.mac.localhost:8154/go
* Agent auto-register Timeout: 3
* Maximum docker containers: 3
* Docker URI: unix:///var/run/docker.sock
* Private registry: false

## Gomatic sample
* Install gomatic: `pip install -r gomatic_sample/requirements.txt`
* Update go config: `python gomatic_sample/sample.py`
