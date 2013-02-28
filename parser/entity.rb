# encoding: utf-8

require_relative './wikicloth/lib/wikicloth.rb'
require 'nokogiri'

class Page
  attr_accessor :title, :id, :redirect
  attr_accessor :properties
  attr_accessor :infobox_type
  attr_accessor :aliases, :aliases_forien
  attr_accessor :categories
  
  attr_accessor :mode
  
  attr_accessor :lang
  
  def initialize(mode = "full")
    self.mode = mode
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
      
      if key =~ /(logo|ロゴ)$/
        html_value.gsub!(/(img src="(.*?)")/) do |m|
          original = $1
          src_fallback = $2
          src_fallback.sub!('commons', "#{lang}")
          "#{original} onerror=\"this.src='#{src_fallback}';\""
        end
      end 
      
      properties[key] = html_value
    end
  end
  
  def plaintext_property!
    html_property!
    properties.each do |key, html_value| 
      plain_value = Nokogiri::HTML(html_value).inner_text
      properties[key] = plain_value
    end
  end
  
  def to_s
    puts "title: #{title}"
    puts "redirect: #{redirect}"
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