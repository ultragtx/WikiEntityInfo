# encoding: utf-8

require 'bzip2'
require_relative 'batch_parser'

class DumpFileParser
  
  def initialize(file_path, lang, compressed)
    if compressed
      bz2_reader = Bzip2::Reader.open(file_path)
      @xml_parser = LibXML::XML::SaxParser.io(bz2_reader)
    else
      @xml_parser = LibXML::XML::SaxParser.file(file_path)
    end
    @batch_parser = BatchParser.new(lang)
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
  # DumpFileParser.new(file_path_en, "en", true).parse

end


