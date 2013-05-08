# encoding: utf-8

require 'libxml'
require_relative 'entity'
require_relative 'info_parser'
require_relative '../database/dbhelper'
require_relative '../database/mysqlhelper'

class BatchParser < InfoParser
  include LibXML::XML::SaxParser::Callbacks
  
  attr_accessor :start_time, :end_time  # for test
  attr_accessor :pages
  attr_accessor :lang
  
  def initialize(lang)
    super(lang)
    @lang = lang
    
    @in_page = false
    @in_title = @in_ns = @in_id = @in_redirect = @in_revision = false
    @in_revid = @in_parentid = @in_timestamp = @in_contributor = false
    @in_username = @in_conid = false
    @in_minor = @in_comment = @in_text = @in_sha1 = @in_model = @in_format = false
    
    @pages = []
    
    @infobox_hash = Hash.new
    @info_count = 0
    
    @page_count = 0

    @dbhelper = DbHelper.new(lang) if USING_SQLITE
    @mysql_helper = MySQLHelper.new(lang)
  end
  
  def on_start_document
    @start_time = Time.now
    puts "on_start_document"
  end
  
  def on_end_document
    @dbhelper.clean_up if USING_SQLITE
    @mysql_helper.clean_up
    
    @end_time = Time.now
    
    puts "on_end_document"
    puts (@end_time - @start_time).to_s
  end
  
  def on_start_element_ns(name, attributes, prefix, uri, namespaces)
    @useful_element = true
    if @in_contributor
      case name
      when "username"
        @in_username = true
      when "id"
        @in_conid = true
      end
    elsif @in_revision
      case name
      when "id"
        @in_revid = true
      when "parentid"
        @in_parentid = true
      when "timestamp"
        @in_timestamp = true
      when "contributor"
        @in_contributor = true
        @useful_element = false
        # @current_page.revision.contributor = Contributor.new
      when "minor"
        @in_minor = true
      when "comment"
        @in_comment = true
      when "text"
        @in_text = true
      when "sha1"
        @in_sha1 = true
      when "model"
        @in_model = true
      when "format"
        @in_format = true
      end
    elsif @in_page
      case name
      when "title"
        @in_title = true
      when "ns"
        @in_ns = true
      when "id"
        @in_id = true
      when "redirect"
        @in_redirect = true
      when "revision"
        @in_revision = true
        @useful_element = false
        # @current_page.revision = Revision.new
      end
    elsif name == "page"
      @in_page = true

      @current_page = Page.new
      @useful_page = false

      @useful_element = false
    else
      @useful_element = false
    end
    
    if @useful_element
      @current_string = String.new
    else
      @current_string = nil
    end
  end
  
  def on_end_element_ns(name, prefix, uri)
    # puts "</#{name}>"
    if @in_contributor
      case name
      when "username"
        @in_username = false
      when "id"
        @in_conid = false
      when "contributor"
        @in_contributor = false
      end
    elsif @in_revision
      case name
      when "id"
        @in_revid = false
        # @current_page.revid = @current_string
      when "parentid"
        @in_parentid = false
        # @current_page.parentid = @current_string
      when "timestamp"
        @in_timestamp = false
        # @current_page.timestamp = @current_string
      when "minor"
        @in_minor = false
        # @current_page.minor = @current_string
      when "comment"
        @in_comment = false
        # @current_page.comment = @current_string
      when "text"
        @in_text = false
        self.get_info
      when "sha1"
        @in_sha1 = false
        @current_page.sha1 = @current_string
      when "model"
        @in_model = false
        # @current_page.model = @current_string
      when "format"
        @in_format = false
        # @current_page.format = @current_string
      when "revision"
        @in_revision = false
      end
    elsif @in_page
      case name
      when "title"
        @in_title = false
        @current_page.title = @current_string
      when "ns"
        @in_ns = false
        # @current_page.ns = @current_string
      when "id"
        @in_id = false
        @current_page.id = @current_string
      when "redirect"
        @in_redirect = false
        @current_page.redirect = @current_string
      when "page"
        @in_page = false
        # @pages += [@current_page]
        # puts "$$#{@current_page}$$"

        if @useful_page
          # Database Storage
          # puts "--------Page [#{@page_count}]----------"
          # puts @current_page
          # 

          # gets
          
          plain_page = @current_page.copy
          plain_page.plaintext_property!
          
          # puts '-----'
          # puts @current_page
          # puts '+++++'
          # puts plain_page
          # 
          # gets 
          
          @dbhelper.insert_page(@current_page) if USING_SQLITE
          @mysql_helper.insert_page(plain_page)
        end
        
        # Clean up test
        # if @page_count > 2000
        #   puts "clean up"
        #   gets
        #   @dbhelper.clean_up
        #   @mysql_helper.clean_up
        #   exit
        # end
      end
    end
    @current_string = nil
  end
  
  def on_characters(chars)
    if @current_string
      @current_string << chars
    end
  end
  
  def get_info
    if @page_count >= 0
      useful_type, infobox_type, infobox_properties = get_infobox(@current_string)
      if useful_type
        @useful_page = true
        aliases = get_alias(@current_string)
        aliases << [@current_page.title]
        aliases.uniq!
        
        categories = get_category(@current_string)
        aliases_forien = get_forien_alias(@current_string)
        
        @current_page.infobox_type = infobox_type
        @current_page.properties = infobox_properties
        @current_page.aliases = aliases
        @current_page.aliases_forien = aliases_forien
        @current_page.categories = categories
        
        @current_page.lang = @lang
      end
    end
    @page_count += 1
    
  end
end
