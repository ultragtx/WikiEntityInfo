# encoding: utf-8

require 'libxml'
require 'bzip2'
require_relative 'entity'
require_relative '../Database/dbhelper'

class SaxCallbacks
  include LibXML::XML::SaxParser::Callbacks
  
  attr_accessor :start_time, :end_time  # for test
  
  attr_accessor :pages
  
  def initialize
    @in_page = false
    @in_title = @in_ns = @in_id = @in_redirect = @in_revision = false
    @in_revid = @in_parentid = @in_timestamp = @in_contributor = false
    @in_username = @in_conid = false
    @in_minor = @in_comment = @in_text = @in_sha1 = @in_model = @in_format = false
    
    @pages = []
    
    @infobox_hash = Hash.new
    @info_count = 0
    
    @page_count = 0

    @dbhelper = DbHelper.new
  end
  
  def on_start_document
    @start_time = Time.now
    puts "on_start_document"
  end
  
  def on_end_document
    @end_time = Time.now
    # @infobox_hash.keys.each {|key| puts "@@#{key}$$"}
    @infobox_hash.keys.each {|key| puts "#{key}"}
    # @infobox_hash.each {|key| puts "#{key}"}
    puts "total info:#{@infobox_hash.count}"
    puts "on_end_document"
    puts "count:#{@info_count}"
    puts (@end_time - @start_time).to_s
  end
  
  def on_start_element_ns(name, attributes, prefix, uri, namespaces)
    # puts "#{name} | #{attributes} | #{prefix} | #{uri} | #{namespaces}"
    # puts "<#{name}>"
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
        # @current_page.revision.contributor.username = @current_string
      when "id"
        @in_conid = false
        # @current_page.revision.contributor.id = @current_string
      when "contributor"
        @in_contributor = false
      end
    elsif @in_revision
      case name
      when "id"
        @in_revid = false
        # @current_page.revision.id = @current_string
        @current_page.revid = @current_string
      when "parentid"
        @in_parentid = false
        # @current_page.revision.parentid = @current_string
        @current_page.parentid = @current_string
      when "timestamp"
        @in_timestamp = false
        # @current_page.revision.timestamp = @current_string
        @current_page.timestamp = @current_string
      when "minor"
        @in_minor = false
        # @current_page.revision.minor = @current_string
        @current_page.minor = @current_string
      when "comment"
        @in_comment = false
        # @current_page.revision.comment = @current_string
        @current_page.comment = @current_string
      when "text"
        @in_text = false
        # @current_page.revision.text = @current_string
        self.get_info
      when "sha1"
        @in_sha1 = false
        # @current_page.revision.sha1 = @current_string
        @current_page.sha1 = @current_string
      when "model"
        @in_model = false
        # @current_page.revision.model = @current_string
        @current_page.model = @current_string
      when "format"
        @in_format = false
        # @current_page.revision.format = @current_string
        @current_page.format = @current_string
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
        @current_page.ns = @current_string
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
          ###@dbhelper.insert_page(@current_page)
        end

      end
    end
    @current_string = nil
  end
  
  def on_characters(chars)
    # printf("$$#{chars[0..[20, chars.length].min]}%%%\n")
    if @current_string
      @current_string << chars
    end
  end
  
  def get_info
      infobox_exp = /\{\{Infobox((.)*?)(\||\}|\<!)/m
      @current_string =~ infobox_exp
      key = $1.to_s
      key.gsub!(/_/, " ")
      key.strip!
      key.downcase!
      if key.length > 0
        # puts "@@#{$1.chomp}$$"
        @infobox_hash[key] = @current_page.title
        @info_count += 1
      end
  end
end

file_path_ja = "/Users/ultragtx/Downloads/jawiki-20130125-pages-articles.xml.bz2"
file_path_en = "/Users/ultragtx/Downloads/enwiki-20130204-pages-articles.xml.bz2"
file_path_zh = "/Users/ultragtx/Downloads/zhwiki-20130204-pages-articles.xml.bz2"

file_path_bz2 = "/Users/ultragtx/Downloads/zhwiki-latest-pages-articles.xml.bz2"
#file_path_bz2 = "/Users/ultragtx/Downloads/enwiki-latest-pages-articles1-1.xml-p000000010p000010000.bz2"
file_path = "/Users/ultragtx/Downloads/zhwiki-latest-pages-articles.xml"
#file_path = "/Users/ultragtx/Downloads/enwiki-latest-pages-articles1-1.xml-p000000010p000010000"

file_path_bz2 = file_path_ja

USE_COMPRESSED_FILE = true

if USE_COMPRESSED_FILE
  bz2_reader = Bzip2::Reader.open(file_path_bz2)
  parser = LibXML::XML::SaxParser.io(bz2_reader)
else
  parser = LibXML::XML::SaxParser.file(file_path)
end

parser.callbacks = SaxCallbacks.new
parser.parse
