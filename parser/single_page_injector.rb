#encoding: UTF-8

require_relative '../db/init'
require_relative '../model/init'
require_relative 'info_parser'
require_relative 'entity'

class SinglePageInjector
  
  def self.inject_page(name, lang, text)
    useful_type, infobox_type, infobox_properties = get_infobox(text)
    
    entity = Entity.new
    entity.name = title
    entity.lang = lang
      
    aliases = get_alias(text)
    categories = get_category(text)
    aliases_forien = get_forien_alias(text)
    
    # set infobox type
    entity.infobox_type = infobox_type
    
    # set forien names
    entity.en_name = aliases_forien[:en]
    entity.zh_name = aliases_forien[:zh]
    entity.ja_name = aliases_forien[:ja]
    
    entity.save # save to get id
    
    # set alias_names
    aliases << entity.name # add current name to aliases
    aliases.uniq!
    
    aliases.each do |name|
      alias_name = AliasName.new
      alias_name.name = name
      alias_name.lang = @lang
      entity.add_alias_name(alias_name)
      alias_name.save
    end
    
    # set properties
    infobox_properties.each do |key, value|
      property = Property.new
      property.key = key
      property.value = value
      property.lang = @lang
      entity.add_property(property)
      property.save
    end
    
    # set categories
    categories.each do |name|
      category = Category.new
      category.name = name
      category.lang = @lang
      entity.add_category(category)
      category.save
    end
  end
end
    