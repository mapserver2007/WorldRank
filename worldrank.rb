# -*- coding: utf-8 -*-
require 'mechanize'
require 'yaml'
require 'log4r'
require 'log4r/evernote'
require 'clockwork'

module WorldRank

class Crawler
  URL = 'http://world-rank.in/rank/%s/km'
  
  def initialize
    MyLogger.auth_token = evernote_auth_token
  end
  
  def run
    url = URL % username
    agent = Mechanize.new
    agent.read_timeout = 30
    agent.user_agent_alias = "Windows IE 8"
    site = agent.get(url)
    table = (site/'div[class="content"]/table')
    rank = table[0].search('td[class="rank"]').text.strip
    distance = table[0].search('td[class="distance"]').text.strip
    runners = table[0].search('td[class="actionmenu"]').text.strip
    ttt = "rank: #{rank}, distance: #{distance}, runners: #{runners}"
    p ttt
    ttt
  end
  
  private
  def load_config(path)
    File.exists?(path) ? YAML.load_file(path) : ENV
  end
  
  def username
    path = File.dirname(__FILE__) + "/config/username.yml"
    load_config(path)["name"]
  end
  
  def evernote_auth_token
    path = File.dirname(__FILE__) + "/config/evernote.auth.yml"
    load_config(path)["auth_token"]
  end
end

end

class MyLogger
  def self.method_missing(name, *args)
    if /(.*?)=$/ =~ name
      instance_variable_set("@#{$1}", args[0])
    else
      logger.send(name.to_s, args[0])
    end
  end
  
  def self.logger
    raise "auth token is empty." if @auth_token.nil?
    return @logger unless @logger.nil?
    @logger = Log4r::Logger.new(name)
    @logger.level = Log4r::INFO
    formatter = Log4r::PatternFormatter.new(
        :pattern => "[%l] %d %C: %M ",
        :date_format => "%Y/%m/%d %H:%M:%Sm"
    )
    stdoutOutputter = Log4r::StdoutOutputter.new('console', {
        :formatter => formatter
    })
    evernoteOutputter = Log4r::EvernoteOutputter.new(name, {
        :env => "production",
        :auth_token => @auth_token,
        :stack => "Log4ever",
        :notebook => "WorldRank",
        :tags => ['Log', 'WorldRank', 'RunKeeper', 'LifeLog'],
        :shift_age => Log4ever::ShiftAge::DAILY,
        :formatter => formatter
    })
    @logger.outputters = [stdoutOutputter, evernoteOutputter]
    @logger
  end
end


include Clockwork

handler {|job| MyLogger.info(job.run)}
every(1.hour, WorldRank::Crawler.new)
