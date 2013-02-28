# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'net/http'
require_relative '../database/dbhelper'
require_relative '../parser/body_utils'
require_relative '../parser/entity'

include InfoGetter

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

def update(lang, limit)
  dbhelper = DbHelper.new
  
  rss_link = "http://#{lang}.wikipedia.org/w/index.php?title=Special:RecentChanges&feed=rss&limit=#{limit}&namespace=0"
  rss_content = fetch_content(rss_link)
  
  date_file_addr = "/Users/ultragtx/DevProjects/Ruby/WikipediaEntityAnalyser2/updater/latest_date.txt"
  if File.exist?(date_file_addr)
    date_file = File.open(date_file_addr, "r+")
    latest_date = DateTime.iso8601(date_file.read)
  else
    date_file = File.open(date_file_addr, "w+")
    latest_date = DateTime.new(1970,1,1)
    date_file << latest_date.to_s
    date_file.flush
  end
  
  first_date = true
  doc = Nokogiri::XML(rss_content)
  doc.xpath("//item").each do |item|
    item_doc = Nokogiri::XML(item.to_s)
    title = item_doc.xpath("//title")[0].inner_text
    date = DateTime.httpdate(item_doc.xpath("//pubDate")[0].inner_text)
    
    puts title
    puts date
    
    break if date < latest_date
    
    page_link = "http://#{lang}.wikipedia.org/w/index.php?action=raw&title=#{title}"
    page_content = fetch_content(page_link)
    
    useful_type, infobox_type, infobox_properties = get_infobox(page_content)
    if useful_type
      page = Page.new
      page.title = title
      
      aliases = get_alias(page_content)
      categories = get_category(page_content)
      aliases_forien = get_forien_alias(page_content)
        
      page.infobox_type = infobox_type
      page.properties = infobox_properties.to_s
      page.aliases = aliases.to_s
      page.aliases_forien = aliases_forien.to_s
      page.categories = categories.to_s
      
      # TODO: insert/modifi database
    end
    
    if first_date
      first_date = false
      date_file.truncate(0)
      date_file.seek(0, IO::SEEK_SET)
      date_file << date.to_s
      date_file.flush
    end
    
    # gets
  end
  date_file.flush
  date_file.close
end

update("zh", 10)

    
    