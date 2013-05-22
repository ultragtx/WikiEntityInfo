#encoding: UTF-8

require_relative '../db/init'
require_relative '../model/init'
require_relative 'properties_map'
require_relative '../translator/sentence_translator'

class CombinedEntity
  attr_accessor :name, :infobox_type, :main_lang, :other_langs
  attr_accessor :properties   #hash
  attr_accessor :alias_names      #array
  attr_accessor :categories   #array
  
  def initialize(name, langs, map_file_path, map_file_langs_order)
    if langs.count < 2
      raise "At least 2 langs"
    end
    
    @entity = Entity.where(name: name, lang: langs[0]).first
    @entity.plaintext_property!
    
    self.name = @entity.name
    self.infobox_type = @entity.infobox_type
    self.alias_names = @entity.alias_names_to_array
    self.categories = @entity.categories_to_array
    self.main_lang = langs[0]
    self.other_langs = langs[1..-1]
    
    @other_langs_names = [];
    
    self.other_langs.each do |lang|
      if lang == "zh"
        @other_langs_names << @entity.zh_name
      elsif lang == "en"
        @other_langs_names << @entity.en_name
      elsif lang == "ja"
        @other_langs_names << @entity.ja_name
      end
    end
    
    self.properties = {}
    
    @old_properties = @entity.properties_to_hash
    
    @properties_map = PropertiesMap.new(map_file_path, map_file_langs_order)
    @langs = langs
    
    if langs.count != @properties_map.langs_count
      raise "Langs count mismatch"
    end
    
    @translators = {}
    self.other_langs.each do |lang|
      @translators[lang] = SentenceTranslator.new(lang, self.main_lang)
    end
  end
  
  def combine
    @properties_map.properties_map.each do |map|
      main_properties = map[0]
      main_property_key = nil
      main_property_value = nil
      main_property_has_content = false
      
      # get the property with value
      main_properties.each do |property_name|
        main_property_key = property_name
        main_property_value = @old_properties[property_name]
        if main_property_value && main_property_value.length > 0
          main_property_has_content = true
          break
        end
      end
      
      # if no propper value, take property value from other language and translate if required
      unless main_property_has_content
        map[1..-2].each_with_index do |other_map, index|
          current_lang = self.other_langs[index]
          
          e = Entity.where(name: @other_langs_names[index], lang: current_lang).first
          e.plaintext_property!
          
          break unless e
          current_properties = e.properties_to_hash
          current_property_key = nil
          current_property_value = nil
          current_property_has_content = false
          
          other_map.each do |property_name|
            current_property_key = property_name
            current_property_value = current_properties[property_name]
            if current_property_value && current_property_value.length > 0
              current_property_has_content = true
              break
            end
          end
          
          # translate
          # TODO: link/url protect
          if map[-1]
            translator = @translators[current_lang]
            if current_property_value && current_property_value.length > 0
              translated_value = translator.translate_centence(current_property_value)
              current_property_value = translated_value if translated_value && translated_value.length > 0
            end
          end
          
          main_property_value = "<<<<#{current_lang}>>>> #{current_property_value}"
          
          break if current_property_has_content
        end
      end
      
      self.properties[main_property_key] = main_property_value
      
    end
  end
  
  def to_s
    puts "title: #{self.name}"
    puts "type: #{self.infobox_type}"
    puts "main lang: #{self.main_lang}"
    puts "other langs: #{self.other_langs}"
    puts "properties:"
    self.properties.each do |key, value|
      puts "#{key} = #{value}"
    end
    
    puts "aliases:"
    self.alias_names.each do |alias_name|
      puts "#{alias_name}"
    end
    
    puts "categories:"
    self.categories do |category|
      puts "#{category}"
    end
  end
end