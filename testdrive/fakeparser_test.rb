# encoding: utf-8

require 'bzip2'
require 'libxml'

class FakeParser 
  include LibXML::XML::SaxParser::Callbacks
  
  attr_accessor :start_time, :end_time  # for test
  
  def on_start_document
    @start_time = Time.now
    puts "on_start_document"
  end
  
  def on_end_document
    @end_time = Time.now
    # @infobox_hash.keys.each {|key| puts "@@#{key}$$"}
    # @infobox_hash.each {|key| puts "#{key}"}
    puts (@end_time - @start_time).to_s
  end
  
end


class FakeDumpFileParser
  
  def initialize(file_path, lang, compressed)
    if compressed
      bz2_reader = Bzip2::Reader.open(file_path)
      @xml_parser = LibXML::XML::SaxParser.io(bz2_reader)
    else
      @xml_parser = LibXML::XML::SaxParser.file(file_path)
    end
    @batch_parser = FakeParser.new()
    @xml_parser.callbacks = @batch_parser
  end
  
  def parse
    @xml_parser.parse
  end
end

if __FILE__ == $0
  
  file_path_ja = "/Users/ultragtx/Downloads/jawiki-20130125-pages-articles.xml.bz2"
  file_path_en = "/Users/ultragtx/Downloads/enwiki-20130204-pages-articles.xml.bz2"
  file_path_zh = "/Users/ultragtx/Downloads/zhwiki-20130204-pages-articles.xml.bz2"

  # DumpFileParser.new(file_path_zh, "zh", true).parse
  # DumpFileParser.new(file_path_ja, "ja", true).parse
  FakeDumpFileParser.new(file_path_en, "en", true).parse

end


