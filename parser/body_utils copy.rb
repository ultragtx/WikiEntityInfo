#encoding: utf-8

require_relative './wikicloth/lib/wikicloth.rb'
require 'nokogiri'

class InfoGetter
  def initialize(lang)
    @infobox_content_exps = []
    @infobox_type_exps = []
    @infobox_types = []
    @infobox_key_value_pair_exps = []
    
    @main_paragraph_exp = /^('''.*?)$/
    @alias_names_exp = /'''(.+?)'''/
    
    case lang
    when "zh"
    when "en"
    when "ja"
    else
      puts "[Error]: InfoGetter initialize lang!"
    end
    
  end
  
  def get_infobox(text)
    useful_type = false
    infobox_type = nil
    infobox_properties = nil
    
    infobox_content_exp = /^{{(Infobox.*?)^\|?}}/m
    # infobox_content_exp = /^{{(基礎情報.*?)^\|?}}/m
    text =~ infobox_content_exp
    infobox_content = $1
    
    if infobox_content
      infobox_type_exp = /^Infobox(.*?)(\||\}|\<!)/m
      # infobox_type_exp = /^基礎情報(.*?)(\||\}|\<!)/m
      infobox_content =~ infobox_type_exp
      infobox_type = $1.to_s
      infobox_type.gsub!(/_/, " ")
      infobox_type.strip!
      infobox_type.downcase!

      if infobox_type == "company"
      # if infobox_type == "会社"
        useful_type = true
        puts "--------Page [#{@page_count}]----------"
        puts "title:#{@current_page.title}" if defined? @current_page
        puts "infobox_type:#{infobox_type}"
    
        infobox_key_value_pair_exps = [/^\s*\|(.*?)=(.*?)(?=^\s*\||\|\s*$|\z)/m, /\|\s*$(.*?)=(.*?)(?=\|\s*$|\z)/m]
        
        for i in 0...infobox_key_value_pair_exps.count
          infobox_properties = Hash.new
          infobox_content.scan(infobox_key_value_pair_exps[i]) do |key, value|
            # puts "debug:#{key}, #{value}"
            wiki_parser = WikiCloth::Parser.new({
              :data => value.strip,
              :params => {}
            })
            plain_value = nil
            begin
              html_value = wiki_parser.to_html
              plain_value = Nokogiri::HTML(html_value).inner_text
            rescue => e
              puts e
              plain_value = value.strip
              gets
            end
            infobox_properties[key.strip] = plain_value
            puts "infobox_properties:#{key.strip}, #{plain_value}"
          end
          
          break unless infobox_properties.empty?
        end
      end
    end
    return useful_type, infobox_type, infobox_properties
  end
  
  def get_alias(text)
    main_paragraph_exp = /^('''.*?)$/
    text =~ main_paragraph_exp
    main_paragraph = $1
    aliases = nil
    
    if main_paragraph
      alias_names_exp = /'''(.+?)'''/
      aliases = []
      main_paragraph.scan(alias_names_exp) do |alias_name|
        puts "alias_names:#{alias_name[0]}"
        aliases << alias_name
      end
    end
    return aliases
  end
  
  def get_category(text)
    categorys_exp = /^\[\[Category:(.*?)\]\]$/
    categories = []
    text.scan(categorys_exp) do |category_name|
      puts "[#{category_name}]"
      categories << category_name
    end
    return categories
  end
  
  def get_forien_alias(text)
    en_alias_exp = /^\[\[en:(.*?)\]\]$/
    zh_alias_exp = /^\[\[zh:(.*?)\]\]$/
    ja_alias_exp = /^\[\[ja:(.*?)\]\]$/
    
    text =~ en_alias_exp
    en_alias = $1
    
    text =~ zh_alias_exp
    zh_alias = $1
    
    text =~ ja_alias_exp
    ja_alias = $1
    

    aliases_forien = Hash.new

    puts "en_alias:#{en_alias}"
    puts "zh_alias:#{zh_alias}"
    puts "ja_alias:#{ja_alias}"

    aliases_forien[:en] = en_alias
    aliases_forien[:zh] = zh_alias
    aliases_forien[:ja] = ja_alias
    
    return aliases_forien
  end
end