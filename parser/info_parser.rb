#encoding: utf-8

require_relative './wikicloth/lib/wikicloth.rb'
require 'nokogiri'

class InfoParser
  def initialize(lang)
    @infobox_content_type_exps = [{:content => /^{{(Infobox.*?)^\|?}}/m, :type => /^Infobox(.*?)(\||\}|\<!)/m}]
    @infobox_useful_types = ["company"]
    @infobox_key_value_pair_exps = [/^\s*\|(.*?)=(.*?)(?=^\s*\||\|\s*$|\z)/m, /\|\s*$(.*?)=(.*?)(?=\|\s*$|\z)/m]
    
    @main_paragraph_exp = /^('''.*?)$/
    @alias_names_exp = /'''(.+?)'''/
    
    @categorys_exp = /^\[\[Category:(.*?)\]\]$/
    
    @en_alias_exp = /^\[\[en:(.*?)\]\]$/
    @zh_alias_exp = /^\[\[zh:(.*?)\]\]$/
    @ja_alias_exp = /^\[\[ja:(.*?)\]\]$/
    
    if lang == "ja"
      @infobox_content_type_exps.insert(0, {:content => /^{{(基礎情報.*?)^\|?}}/m, :type => /^基礎情報(.*?)(\||\}|\<!)/m})
      @infobox_useful_types = ["会社"] + @infobox_useful_types
    end
    
  end
  
  def get_infobox(text)
    useful_type = false
    infobox_type = nil
    infobox_properties = nil
    
    @infobox_content_type_exps.each do |infobox_content_type_exp_pair|
      infobox_content_exp = infobox_content_type_exp_pair[:content]
      text =~ infobox_content_exp
      infobox_content = $1
    
      if infobox_content
        infobox_type_exp = infobox_content_type_exp_pair[:type]
        infobox_content =~ infobox_type_exp
        infobox_type = $1.to_s
        infobox_type.gsub!(/_/, " ")
        infobox_type.strip!
        infobox_type.downcase!

        if @infobox_useful_types.include? infobox_type
          useful_type = true

          # puts "infobox_type:#{infobox_type}"
          @infobox_key_value_pair_exps.each do |infobox_key_value_pair_exp|
            infobox_properties = Hash.new
            infobox_content.scan(infobox_key_value_pair_exp) do |key, value|
              wiki_parser = WikiCloth::Parser.new({:data => value.strip})
              plain_value = nil
              begin
                html_value = wiki_parser.to_html
                plain_value = Nokogiri::HTML(html_value).inner_text
              rescue => e # rescue from a wiki_cloth fail
                puts e
                # TODO: Print e to a error file
                plain_value = value.strip
                # gets
              end
              infobox_properties[key.strip] = plain_value
              # puts "infobox_properties:#{key.strip}, #{plain_value}"
            end
            break unless infobox_properties.empty?
          end
          break #get a useful infobox and stop watching another posible infobox with different name
        end
      end 
    end
    return useful_type, infobox_type, infobox_properties
  end
  
  def get_alias(text)
    text =~ @main_paragraph_exp
    main_paragraph = $1
    aliases = nil
    
    if main_paragraph
      aliases = []
      main_paragraph.scan(@alias_names_exp) do |alias_name|
        # puts "alias_names:#{alias_name[0]}"
        aliases << alias_name
      end
    end
    return aliases
  end
  
  def get_category(text)
    categories = []
    text.scan(@categorys_exp) do |category_name|
      # puts "[#{category_name}]"
      categories << category_name
    end
    return categories
  end
  
  def get_forien_alias(text)
    text =~ @en_alias_exp
    en_alias = $1
    
    text =~ @zh_alias_exp
    zh_alias = $1
    
    text =~ @ja_alias_exp
    ja_alias = $1
    

    aliases_forien = Hash.new

    # puts "en_alias:#{en_alias}"
    # puts "zh_alias:#{zh_alias}"
    # puts "ja_alias:#{ja_alias}"

    aliases_forien[:en] = en_alias
    aliases_forien[:zh] = zh_alias
    aliases_forien[:ja] = ja_alias
    
    return aliases_forien
  end
end