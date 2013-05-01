#encoding: utf-8

require_relative './logo_utils'

class InfoParser
  def initialize(lang)
    #^{{(Infobox.*?)^\|?}}
    #^{{(Infobox.*)}}.*?'''

    @infobox_content_type_exps = [{:content => /^{{(Infobox.*?)^\|?}}/m, 
                                   :type => /^Infobox(.*?)(\||\}|\<!)/m, 
                                   :logo_key => /logo$/,
                                   :logo_value => /\[\[(File|Image):([^\|]*?)(\|([^\|]*?))?(\|([^\|]*?))?\]\]/ }]
    @infobox_useful_types = [/company/]
    # @infobox_useful_types = [/company/, /university/, /organization/, 
    #                          /organisation/, /agency/, /school/]
    @infobox_key_value_pair_exps = [/^\s*\|(.*?)=(.*?)(?=^\s*\||\|\s*$|\z)/m, /\|\s*$(.*?)=(.*?)(?=\|\s*$|\z)/m]
    
    @main_paragraph_exp = /^('''.*?)$/
    @alias_names_exp = /'''(.+?)'''/
    
    @categorys_exp = /^\[\[Category:(.*?)\]\]$/
    
    @image_exts = [/jpg/i, /png/i, /svg/i, /gif/i]
    
    @en_alias_exp = /^\[\[en:(.*?)\]\]$/
    @zh_alias_exp = /^\[\[zh:(.*?)\]\]$/
    @ja_alias_exp = /^\[\[ja:(.*?)\]\]$/
    
    @lang = lang
    
    if lang == "ja"
      # @infobox_content_type_exps.insert(0, {:content => /^{{(大学.*?)^\|?}}/m, 
      #                                       :type => "大学",
      #                                       :logo_key => /(ロゴ|画像|紋章)$/,
      #                                       :logo_value => /\[\[(ファイル|File|Image|画像):([^\|]*?)(\|([^\|]*?))?(\|([^\|]*?))?\]\]/,
      #                                       :special => true})

      # @infobox_content_type_exps.insert(0, {:content => /^{{(行政官庁.*?)^\|?}}/m, 
      #                                       :type => "行政官庁",
      #                                       :logo_key => /(ロゴ|画像|紋章)$/,
      #                                       :logo_value => /\[\[(ファイル|File|Image|画像):([^\|]*?)(\|([^\|]*?))?(\|([^\|]*?))?\]\]/,
      #                                       :special => true})
                                            
      @infobox_content_type_exps.insert(0, {:content => /^{{(基礎情報.*?)^\|?}}/m, 
                                            :type => /^基礎情報(.*?)(\||\}|\<!)/m,
                                            :logo_key => /(ロゴ|画像|紋章)$/,
                                            :logo_value => /\[\[(ファイル|File|Image|画像):([^\|]*?)(\|([^\|]*?))?(\|([^\|]*?))?\]\]/})
                                            
      @infobox_useful_types = [/会社/] + @infobox_useful_types
      # @infobox_useful_types = [/会社/, /組織/] + @infobox_useful_types
      
    end
    
    if lang == "zh"
      @infobox_useful_types = @infobox_useful_types + [/大学/, /组织/]
    end
    
  end
  
  def get_infobox(text)
    useful_type = false
    infobox_type = ""
    infobox_properties = {}
    
    @infobox_content_type_exps.each do |infobox_content_type_exp_pair|
      infobox_content_exp = infobox_content_type_exp_pair[:content]
      text =~ infobox_content_exp
      infobox_content = $1
      
      if infobox_content
        if infobox_content_type_exp_pair[:special]
          infobox_type = infobox_content_type_exp_pair[:type]
          useful_type = true
        else
          infobox_type_exp = infobox_content_type_exp_pair[:type]
          infobox_content =~ infobox_type_exp
          infobox_type = $1.to_s
          infobox_type.gsub!(/_/, " ")
          infobox_type.strip!
          infobox_type.downcase!
        
          @infobox_useful_types.each do |type|
            if infobox_type =~ type
              useful_type = true
              break
            end
          end
        end
        
        # if @infobox_useful_types.include? infobox_type
        #   useful_type = true
        
        if useful_type
          # puts "infobox_type:#{infobox_type}"
          @infobox_key_value_pair_exps.each do |infobox_key_value_pair_exp|
            infobox_content.scan(infobox_key_value_pair_exp) do |key, value|
              stripped_key = key.strip
              stripped_value = value.strip
              if stripped_key =~ infobox_content_type_exp_pair[:logo_key] 
                match_file_template = false
                stripped_value.gsub!(infobox_content_type_exp_pair[:logo_value]) do |m|
                  # match [[File:xxxxxx.xxx|xxx|xxx]]
                  match_file_template = true
                  logo_name = $2 || "" 
                  logo_size = $4 || ""
                  logo_desc = $6 || ""
                  
                  logo_link = LogoUtils.link_for_logo(logo_name, "commons")
                  
                  "[[File:#{logo_link}|#{logo_size}|#{logo_desc}]]"
                end

                unless match_file_template
                  # match xxxxx.xxx
                  logo_link = LogoUtils.link_for_logo(stripped_value, "commons")
                  stripped_value = "[[File:#{logo_link}]]"
                end
                
                # puts stripped_value
                # gets
              end
              infobox_properties[stripped_key] = stripped_value
              # puts "infobox_properties:#{stripped_key}, #{stripped_value}"
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
    aliases = []
    
    if main_paragraph
      main_paragraph.scan(@alias_names_exp) do |alias_name|
        # puts "alias_names:#{alias_name[0]}"
        aliases << alias_name[0] # alias_name is an arry
      end
    end
    return aliases
  end
  
  def get_category(text)
    categories = []
    text.scan(@categorys_exp) do |category_name|
      # puts "[#{category_name}]"
      categories << category_name[0] # category_name is an arry
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