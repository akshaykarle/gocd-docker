FROM gocd/gocd-server:v17.8.0

RUN apk --no-cache add docker

RUN mkdir -p godata/config
COPY cruise-config.xml.sample godata/config/cruise-config.xml

RUN mkdir -p godata/plugins/external
ADD https://github.com/gocd-contrib/docker-elastic-agents/releases/download/v0.7.0/docker-elastic-agents-0.7.0.jar godata/plugins/external
ADD https://github.com/tomzo/gocd-yaml-config-plugin/releases/download/0.4.0/yaml-config-plugin-0.4.0.jar godata/plugins/external
ADD https://github.com/gocd-contrib/github-oauth-authorization-plugin/releases/download/1.0.0/github-oauth-authorization-plugin-1.0.0-1.jar godata/plugins/external

ENTRYPOINT ["/docker-entrypoint.sh"]
