#!/usr/bin/env python
from gomatic import *

configurator = GoCdConfigurator(HostRestClient("localhost:8153", username="gomatic", password="gomatic"))

auth_configs = configurator.ensure_security().ensure_auth_configs()
auth_configs.ensure_replacement_of_auth_config(auth_config_id='gomatic',
        plugin_id='cd.go.authentication.passwordfile',
        properties={'PasswordFilePath': '/godata/gomatic-passwd'})

elastic_profiles = configurator.ensure_elastic().ensure_replacement_of_profiles()
elastic_profile = elastic_profiles.ensure_replacement_of_profile(profile_id='test',
        plugin_id='cd.go.contrib.elastic-agent.docker',
        properties={'Image': 'gocd/gocd-agent-alpine-3.5:v17.8.0'})

pipeline = configurator \
    .ensure_pipeline_group("defaultGroup") \
    .ensure_replacement_of_pipeline("first_gomatic_pipeline") \
    .set_git_url("https://github.com/gocd-contrib/gomatic.git")
stage = pipeline.ensure_stage("stage")
job = stage.ensure_job("job").set_elastic_profile_id(elastic_profile.profile_id)
job.add_task(ExecTask(['ls']))


configurator.save_updated_config()
