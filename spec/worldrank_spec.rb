# -*- coding: utf-8 -*-
require 'rspec'
require 'yaml'
require File.dirname(__FILE__) + "/../worldrank"

describe WorldRank, 'が実行する処理' do
  let(:worldrank) {
    WorldRank::Crawler.new
  }
  
  it 'WorldRank.inのデータを取得できること' do
    worldrank.run.should_not be_nil
  end
end
