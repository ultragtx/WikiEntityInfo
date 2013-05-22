#encoding: UTF-8

require_relative 'translator'
require "mecab/ext"
require 'rmmseg'
require 'bing_translator'

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
    
    #bing translator
    @bing_translator = BingTranslator.new("wikientityinfo", "HxD+q3eLEWjGaqoVJDWNUlUXZWJX/L9YW0toR148xS8")
  end
  
  def translate_centence(sentence)
    result = ""
    
    if @translator
      if @from_lang == "en"
        spliter = EngSpliter.new(sentence)
        spliter.words.each do |word|
          word.downcase!
          trans = @translator.translate(word, @from_lang)
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
        nodes = Mecab::Ext::Parser.parse(sentence)
        nodes.each do |node|
          trans = @translator.translate(node.surface, @from_lang)
          if trans
            trans = " #{trans} " if @to_lang == "en"
            result << trans
          else
            result << node.surface
          end
        end
      end
    else 
      # bing translate
      if @to_lang == "zh"
        trans_to = "zh-CN"
      else
        trans_to = @to_lang
      end
      
      result << (@bing_translator.translate sentence, :to => trans_to)
    end
    
    result
  end
end