# encoding: utf-8

require_relative './wikicloth/lib/wikicloth.rb'
require 'nokogiri'

class Page
  attr_accessor :title, :id, :redirect
  attr_accessor :properties
  attr_accessor :infobox_type
  attr_accessor :aliases, :aliases_forien
  attr_accessor :categories
  
  attr_accessor :sha1
  
  attr_accessor :mode
  
  attr_accessor :lang
  
  def initialize(mode = "full")
    self.mode = mode
  end
  
  def copy
    page = Page.new(self.mode)
    page.title = self.title.dup if self.title
    page.id = self.id.dup if self.id
    page.redirect = self.redirect.dup if self.redirect
    page.sha1 = self.sha1.dup if self.sha1
    page.lang = self.lang.dup if self.lang
    page.infobox_type = self.infobox_type.dup if self.infobox_type
    
    page.aliases = []
    self.aliases.each do |alias_name|
      page.aliases << alias_name.dup
    end
    
    page.aliases_forien = {}
    self.aliases_forien.each do |key, value|
      value ||= ""
      page.aliases_forien[key] = value.dup
    end
    
    page.categories = []
    self.categories.each do |category|
      page.categories << category.dup
    end

    if self.mode == "string"
      page.properties = self.properties.dup if self.properties
    elsif self.mode == "full"
      page.properties = {}
      self.properties.each do |key, value|
        value ||= ""
        page.properties[key] = value.dup
      end
    end

    return page
  end
  
  def self.new_page_with_hash_lang(page_hash, lang)
    page = Page.new("string")
    
    page.title = page_hash[:title]
    page.redirect = page_hash[:redirect]
    page.properties = page_hash[:properties]
    page.infobox_type = page_hash[:infobox_type]
    page.aliases = page_hash[:aliases]
    page.aliases_forien = page_hash[:aliases_forien]
    page.categories = page_hash[:categories]
    
    page.sha1 = page_hash[:sha1]
    
    page.lang = lang
    
    page.full_mode!
    
    return page
  end
  
  def full_mode!
    if self.mode != "full"
      self.mode = "full"
      
      self.properties = eval(self.properties)
      self.aliases = eval(self.aliases)
      self.aliases_forien = eval(self.aliases_forien)
      self.categories = eval(self.categories)
    end
  end
  
  def string_mode!
    if self.mode != "string"
      self.mode = "string"
      
      self.properties = self.properties.to_s
      self.aliases = self.aliases.to_s
      self.aliases_forien = self.aliases_forien.to_s
      self.categories = self.categories.to_s
    end
  end
  
  def html_property!
    full_mode! if self.mode != "full"
    properties.each do |key, value| 
      raw_value = value
      # raw_value = " " + value
      raw_value.gsub!(/(\{\{(.*?)\}\})/m) do |template|
        content = $2
        content.gsub!('|',' ')
        content.gsub!('=', ':')
        content + " "
      end
      
      wiki_parser = WikiCloth::Parser.new({:data => raw_value})
      
      html_value = nil
      begin
        html_value = wiki_parser.to_html
      rescue => e # rescue from a wiki_cloth fail
        puts e
        # TODO: Print e to a error file
        html_value = value
        # gets
      end
      
      # html_value.chomp!
      
      if key =~ /(logo|ロゴ|画像)$/
        html_value.gsub!(/(img src="(.*?)")/) do |m|
          original = $1
          src_fallback = $2
          src_fallback.sub!('commons', "#{lang}")
          "#{original} onerror=\"this.src=\"#{src_fallback}\";\""
        end
      end 
      
      properties[key] = html_value
    end
  end
  
  def plaintext_property!
    html_property!
    properties.each do |key, html_value|
      if key =~ /(logo|ロゴ|画像)$/

        html_value.gsub!(/(<img.*?>)/m) do |img|
          links = ""
          img.scan(/src="(.*?)" onerror="this.src="(.*?)"/m) do |link, fall_link|
            links = "[" + link + ", " + fall_link + "]"
          end
          links
        end
      end
        
      doc = Nokogiri::HTML(html_value)
      doc.css("br").each { |node| node.replace("\n") }
      plain_value = doc.text
      properties[key] = plain_value
    end
  end
  
  def to_s
    puts "title: #{title}"
    puts "redirect: #{redirect}"
    puts "sha1: #{sha1}"
    puts "infobox_type: #{infobox_type}"
    if self.mode == "string"
      puts "infobox_properties: \n#{properties}"
      puts "aliases: #{aliases}"
      puts "aliases_forien: #{aliases_forien}"
      puts "categories: #{categories}"
    elsif self.mode == "full"
      properties.each do |key, value|
        puts "infobox_properties: #{key}, #{value}"
      end
      if aliases
        aliases.each do |alias_name|
          puts "alias: #{alias_name}"
        end
      end
      aliases_forien.each do |key, value|
        puts "alias_forien: #{key}, #{value}"
      end
      categories.each do |category|
        puts "category: #{category}"
      end
    end
  end
end