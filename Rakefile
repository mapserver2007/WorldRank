# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/worldrank'
require 'rspec/core/rake_task'
require 'yaml'

config_files = [
  YAML.load_file(File.dirname(__FILE__) + "/config/evernote.auth.yml"),
  YAML.load_file(File.dirname(__FILE__) + "/config/username.yml")
]

config = {}
config_files.each do |file|
  file.each {|key, value| config[key] = value}
end

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

task :heroku_env => [:heroku_env_clean, :timezone] do
  config.each do |key, value|
    sh "heroku config:add #{key}=#{value}"
  end
end

task :heroku_env_clean do
  config.each do |key, value|
    sh "heroku config:remove #{key}"
  end
end

task :timezone do
  sh "heroku config:add TZ=Asia/Tokyo"
end

task :heroku_start do
  sh "heroku scale clock=1"
end

task :heroku_stop do
  sh "heroku scale clock=0"
end