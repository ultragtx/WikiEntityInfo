#encoding: UTF-8

require 'sequel'
require_relative '../parser/wikicloth/lib/wikicloth.rb'
require 'nokogiri'

class Entity < Sequel::Model
  one_to_many :alias_names
  one_to_many :properties
  one_to_many :categories
  
  def html_property!
    self.properties.each do |property|
      raw_value = property.value
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
      
      if property.key =~ /(logo|ロゴ|画像)$/
        html_value.gsub!(/(img src="(.*?)")/) do |m|
          original = $1
          src_fallback = $2
          src_fallback.sub!('commons', "#{lang}")
          "#{original} onerror=\"this.src=\'#{src_fallback}\';\""
        end
      end
      
      property.value = html_value
    end
  end
  
  def plaintext_property!
    html_property!
    properties.each do |property|
      if property.key =~ /(logo|ロゴ|画像)$/

        property.value.gsub!(/(<img.*?>)/m) do |img|
          links = ""
          img.scan(/src="(.*?)" onerror="this.src='(.*?)'/m) do |link, fall_link|
            links = "[" + link + ", " + fall_link + "]"
          end
          links
        end
      end
        
      doc = Nokogiri::HTML(property.value)
      doc.css("br").each { |node| node.replace("\n") }
      plain_value = doc.text
      property.value = plain_value
    end
  end
  
  def escape_html_property!
    self.properties.each do |property|
      property.value = Rack::Utils.escape_html(property.value)
    end
  end
  
  def properties_to_hash
    p = {}
    self..properties.each do |property|
        p[property.key] = property.value
    end
    p
  end
  
  def alias_names_to_array
    a = []
    self.alias_names.each do |alias_name|
      a << alias_name.name
    end
    a
  end
  
  def categories_to_array
    a = []
    self.categories.each do |category|
      a << category.name
    end
    a
  end
  
  def to_s
    puts "title: #{self.name}"
    puts "redirect: #{self.redirect}" if self.redirect
    puts "infobox_type: #{self.infobox_type}"

    self.properties.each do |property|
      puts "infobox_properties: #{property.key}, #{property.value}"
    end
    if self.alias_names
      self.alias_names.each do |alias_name|
        puts "alias: #{alias_name.name}"
      end
    end
  
    self.categories.each do |category|
      puts "category: #{category.name}"
    end
    
    puts "en: #{self.en_name}"
    puts "zh: #{self.zh_name}"
    puts "ja: #{self.ja_name}"
  end
  
  def to_full_json
    # self.to_json(except: [:id])
    self.to_json(except: [:id], 
                 include: {alias_names: {only: [:name]},
                           properties: {only: [:key, :value]}, 
                           categories: {only: [:name]}
                          })
  end
end