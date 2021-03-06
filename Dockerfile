FROM gocd/gocd-server:v17.8.0

RUN apk --no-cache add docker

RUN \
  mkdir -p /godata/config && \
  mkdir -p /godata/plugins/external

COPY cruise-config.xml.sample /godata/config/cruise-config.xml
COPY log4j-stdout.properties /godata/config/log4j.properties
COPY gomatic-passwd /godata/gomatic-passwd

ADD https://github.com/gocd-contrib/docker-elastic-agents/releases/download/v0.7.0/docker-elastic-agents-0.7.0.jar /godata/plugins/external/
ADD https://github.com/gocd-contrib/github-oauth-authorization-plugin/releases/download/1.0.0/github-oauth-authorization-plugin-1.0.0-1.jar /godata/plugins/external/

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
