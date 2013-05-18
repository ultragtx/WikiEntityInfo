#encoding: UTF-8

class CombinedEntity
  attr_accessor :name, :infobox_type, :main_lang, :other_langs
  attr_accessor :properties   #hash
  attr_accessor :aliases      #array
  attr_accessor :categories   #array
  
  def initialize(main_lang, other_langs)
    
  end
end