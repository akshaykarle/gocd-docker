#!/usr/bin/env python
from gomatic import *

configurator =  GoCdConfigurator(HostRestClient("localhost:8153", username="gomatic", password="gomatic"))
pipeline = configurator \
    .ensure_pipeline_group("defaultGroup") \
    .ensure_replacement_of_pipeline("first_gomatic_pipeline") \
    .set_git_url("https://github.com/gocd-contrib/gomatic.git")
stage = pipeline.ensure_stage("stage")
job = stage.ensure_job("job").set_elastic_profile_id("test")
job.add_task(ExecTask(['ls']))

configurator.save_updated_config()
