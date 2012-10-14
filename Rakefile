# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/worldrank'
require 'rspec/core/rake_task'
require 'yaml'

task:default => [:spec, :github_push, :heroku_deploy]

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['-cfs']
end

task :github_push => [:spec] do
  sh 'git push origin master'
end

task :heroku_deploy => [:github_push] do
  sh 'git push heroku master'
end

task :heroku_env => [:timezone] do
  evernote_config = YAML.load_file(File.dirname(__FILE__) + "/config/evernote.auth.yml")
  username_config = YAML.load_file(File.dirname(__FILE__) + "/config/username.yml")
  config = evernote_config.merge(username_config)
  config.each do |key, value|
    sh "heroku config:add #{key}='#{value}'"
  end
end

task :timezone do
  sh "heroku config:add TZ=Asia/Tokyo"
end