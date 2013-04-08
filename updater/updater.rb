# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'fileutils'
require_relative '../parser/wiki_parser'
require_relative "../global/settings"

def fetch_content(link)
  # puts link
  # remote = open(URI::encode(link), 'User-Agent' => 'Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25')
  remote = open(URI::encode(link), 'User-Agent' => 'Ruby')
  data = remote.read
  remote.close
  data
  
  # data = Net::HTTP.get(URI.parse(URI::encode(link)))
  # puts data
  # data
end

def wget_dump(link)
  encoded_link = URI::encode(link)
  puts "download start: #{encoded_link}"
  # exec("wget -p \"#{DUMP_FILE_DIR}\" \"#{encoded_link}\"")
  puts "wget -c -P \"#{DUMP_FILE_DIR}/\" \"#{encoded_link}\""
  %x[bash --login -c "echo $PATH; wget -c -P \"#{DUMP_FILE_DIR}/\" \"#{encoded_link}\""]
  puts "download end"
end

def update(lang)
  dump_rss_link = "http://dumps.wikimedia.org/#{lang}wiki/latest/#{lang}wiki-latest-pages-articles.xml.bz2-rss.xml"
  
  rss_content = fetch_content(dump_rss_link)
  # rss_content = Text
  # rss_content =~ /href="([^"]*)"/
  rss_content =~ /href="([^"]*\/([^\/]*\.bz2))"/
  if $1
    new_dump = $1
    new_dump_file_name = $2
    puts "new_dump   : #{new_dump}"
    puts "file_name  : #{new_dump_file_name}"
    
    latest_file_addr = "#{DUMP_FILE_DIR}/latest_#{lang}.txt"
    
    if File.exist?(latest_file_addr)
      latest_file = File.open(latest_file_addr, "r+")
      latest_dump = latest_file.read
    else
      latest_file = File.open(latest_file_addr, "w+")
      latest_dump = nil
    end
    
    puts "latest_dump: #{latest_dump}"
    
    if new_dump != latest_dump
      puts "dump file has update"
      # download dump file and parse
      wget_dump(new_dump)
      
      file_path = "#{DUMP_FILE_DIR}/#{new_dump_file_name}"
      DumpFileParser.new(file_path, lang, true).parse
      
      # write the new url to the file
      latest_file.truncate(0)
      latest_file.seek(0, IO::SEEK_SET)
      latest_file << new_dump
      latest_file.flush
    else
      puts "dump file up to date"
    end
    
    latest_file.close
    
  end
end

# wget_dump("http://baidu.com")
update("en")
update("zh")
update("ja")

    
    