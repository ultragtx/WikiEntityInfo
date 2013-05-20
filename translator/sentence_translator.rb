#encoding: UTF-8

require_relative 'translator'

class SentenceTranslator
  
  def initialize(from_lang, to_lang)
    
    if (from_lang == "en" && to_lang == "zh")
      @translator = CustomTranslator.translator_with_lang("E2C")
    elsif (from_lang == "zh" && to_lang == "en")
      @translator = CustomTranslator.translator_with_lang("C2E")
    elsif (from_lang == "en" && to_lang == "ja")
      @translator = CustomTranslator.translator_with_lang("E2J")
    elsif  (from_lang == "ja" && to_lang == "en")
      @translator = CustomTranslator.translator_with_lang("J2E")
    elsif  (from_lang == "zh" && to_lang == "ja")
      @translator = CustomTranslator.translator_with_lang("C2J")
    elsif  (from_lang == "ja" && to_lang == "zh")
      @translator = CustomTranslator.translator_with_lang("J2C")
    end
    
  end
  
  def translate_centence(centence)
    if @translator
      
    else 
      # TODO: Using Bing / youdao
      return centence
    end
  end
  
  
end