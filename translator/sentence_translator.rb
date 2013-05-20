#encoding: UTF-8

require_relative 'translator'
require "mecab/ext"
require 'rmmseg'

class EngSpliter
  attr_accessor :words
  def initialize(sentence)
    self.words = sentence.split(/[\?.,]?[ ]+/)
  end
end

class SentenceTranslator
  
  def initialize(from_lang, to_lang)
    
    if (from_lang == "en" && to_lang == "zh")
      @translator = CustomTranslator.translator_with_lang("E2C")
    elsif (from_lang == "zh" && to_lang == "en")
      @translator = CustomTranslator.translator_with_lang("C2E")
      RMMSeg::Dictionary.load_dictionaries
    elsif (from_lang == "en" && to_lang == "ja")
      @translator = CustomTranslator.translator_with_lang("E2J")
    elsif  (from_lang == "ja" && to_lang == "en")
      @translator = CustomTranslator.translator_with_lang("J2E")
    elsif  (from_lang == "zh" && to_lang == "ja")
      @translator = CustomTranslator.translator_with_lang("C2J")
    elsif  (from_lang == "ja" && to_lang == "zh")
      @translator = CustomTranslator.translator_with_lang("J2C")
    end
    
    @from_lang = from_lang
    @to_lang = to_lang
  end
  
  def translate_centence(sentence)
    result = ""
    
    if @translator
      if @from_lang == "en"
        spliter = EngSpliter.new(sentence)
        spliter.words.each do |word|
          trans = @translator.translate(word, @to_lang)
          if trans
            result << trans
          else
            result << " #{word} "
          end
        end
      elsif @from_lang == "zh"
        algo = RMMSeg::Algorithm.new(sentence)
        loop do
            token = algo.next_token
            break if token.nil?
            trans = @translator.translate(token.text.force_encoding("UTF-8"), @from_lang)
            if trans
              trans = " #{trans} " if @to_lang == "en"
              result << trans
            else
              result << token.text
            end
        end
        
      elsif @from_lang == "ja"
        
      end
    else 
      # TODO: Using Bing / youdao
      return centence
    end
    
    result
  end
end