# encoding: utf-8

class Page
  attr_accessor :title, :id, :redirect
  # attr_accessor :ns
  # attr_accessor :revid, :parentid, :timestamp, :minor, :comment, :text, :sha1, :model, :format
  attr_accessor :properties
  attr_accessor :infobox_type
  attr_accessor :aliases, :aliases_forien
  attr_accessor :categories
  
  attr_accessor :mode
  
  def initialize(mode = "full")
    self.mode = mode
  end
  
  def self.new_page_with_hash(page_hash)
    page = Page.new("string")
    
    page.title = page_hash[:title]
    page.redirect = page_hash[:redirect]
    page.properties = page_hash[:properties]
    page.infobox_type = page_hash[:infobox_type]
    page.aliases = page_hash[:aliases]
    page.aliases_forien = page_hash[:aliases_forien]
    page.categories = page_hash[:categories]
    
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
      aliases.each do |alias_name|
        puts "alias: #{alias_name}"
      end
      aliases_forien.each do |key, value|
        puts "alias_forien: #{key}, #{value}"
      end
      categories.each do |category|
        puts "category: #{category}"
      end
    end
  end
      
  
  # def to_s
#     "title:#{@title}\nns:#{@ns}\nid:#{id}\nredirect:#{@reidrect}\nrevision:\n#{@revision}\n"
#   end
end