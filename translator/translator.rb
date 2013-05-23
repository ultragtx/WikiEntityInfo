#encoding: UTF-8

require 'active_support/all'

class DictEntry
  attr_accessor :word
  attr_accessor :type
  attr_accessor :translations
  
  def initialize(comps, num_comps)
    raise "comps should = #{num_comps}" if comps.count != num_comps
    
    self.word = comps[0]
    self.type = comps[1] if num_comps > 2
    
    self.translations = []
    
    comps[-1].split(";").each do |translation|
      if translation =~ /^&&PY=(.*)/
        self.translations << $1
      elsif translation =~ /^\*(.*)/
        self.translations << $1
      else
        self.translations << translation
      end
    end
  end
  
  # def to_s
#     puts "[#{self.word}] (#{self.type}):"
#     puts "----------------"
#     puts self.translations
#     puts "================"
#   end
  
end


class Translator
  attr_accessor :dictionary #Hash
  
  def initialize(dict_path, num_comps)
    self.dictionary = {}
    parse_dict(dict_path, num_comps)
  end
  
  def parse_dict(dict_path, num_comps)
    file = open(dict_path)
    dict_content = file.read
    file.close
    
    # dict_content = "#啊\\e/y\\&&PY=a;*ah;*;"
    
    dict_content.scan(/^#(.*?)$/) do |line|
      line = line[0]
      # puts line
      
      comps = line.split("\\")
      
      dict_entry = DictEntry.new(comps, num_comps)
      # puts dict_entry
      # gets
      
      self.dictionary[dict_entry.word] = dict_entry
    end
  end
  
  def translate(word, from_lang)
    # puts "word: #{word}"
    entry = self.dictionary[word]
    if entry
      # puts "text: #{entry.translations[0]}"
      return entry.translations[0]
    else
      if from_lang == "zh" && word.length > 1
        result = ""
        word.each_char do |char|
          trans = translate(char, from_lang)
          if trans 
            result << trans
          else
            result << char
          end
        end
        return result
      elsif from_lang == "en"
        result = nil
        plural_word = word.singularize
        if plural_word != word
          result = translate(plural_word, from_lang)
        end
        return result
      else
        return nil
      end
    end
  end
end

class CustomTranslator
  @@e2c = nil
  @@c2e = nil
  def self.translator_with_lang(lang)
    if lang == "E2C"
      @@e2c = Translator.new('/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/translator/dictionary/E2C.dic', 2) unless @@e2c
      @@e2c
    elsif lang == "C2E"
      @@c2e = Translator.new('/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/translator/dictionary/C2E.dic', 3) unless @@c2e
      @@c2e
    end
  end
end