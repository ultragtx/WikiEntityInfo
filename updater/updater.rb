# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'net/http'
require_relative '../parser/wiki_parser'

def fetch_content(link)
  puts link
  # remote = open(URI::encode(link), 'User-Agent' => 'Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25')
  remote = open(URI::encode(link), 'User-Agent' => 'Ruby')
  data = remote.read
  remote.close
  data
  
  # data = Net::HTTP.get(URI.parse(URI::encode(link)))
  # puts data
  # data
end

def update(lang)
  dump_rss_link = "http://dumps.wikimedia.org/#{lang}wiki/latest/#{lang}wiki-latest-pages-articles.xml.bz2-rss.xml"
  
  latest_file_addr = "/Users/ultragtx/DevProjects/Ruby/WikipediaEntityAnalyser2/updater/latest_#{lang}.txt"
  if File.exist?(latest_file_addr)
    latest_file = File.open(latest_file_addr, "r+")
    latest_dump = latest_file.read
  else
    latest_file = File.open(latest_file_addr, "w+")
    latest_dump = nil
    date_file << latest_dump.to_s
    date_file.flush
  end
  
end


update("en")
update("zh")
update("ja")

    
    