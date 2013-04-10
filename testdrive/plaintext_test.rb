# encoding: utf-8

require 'nokogiri'
require 'timeout'

my_html = <<TEXT
 <p><img src="http://upload.wikimedia.org/wikipedia/zh/b/b1/Chinamobile.png" onerror="this.src='http://upload.wikimedia.org/wikipedia/zh/b/b1/Chinamobile.png';" alt="" title="" style="width:175px"></p>
TEXT

doc = Nokogiri::HTML(my_html)
doc.css("br").each { |node| node.replace("\n") }
puts doc.text

class Nokogiri::XML::Node
  def inner_html_reject(xpath='.//comment()')
    dup.tap{ |shadow| shadow.xpath(xpath).remove }.inner_html
  end
end

text = <<TEXT
asdf <!-- OPTIONAL : State school colours, using words, then <br>then
                                         {{colorbox|#xxyyzz}} -->
TEXT

puts "test exit"

i = 0
while i < 100
  i++
  exit
end 

puts "test exit end"


s = Time.now
i = 0
while i < 1
  Timeout::timeout(5) {
    # text.gsub('<!--(.|\s)*?-->')
    doc  = Nokogiri::HTML(text)
                     
    doc.xpath('//comment()').remove
    p doc.css("body.item:first").inner_html  
    # p doc.inner_html_reject
    # p doc.text
  }
  i += 1
end


e = Time.now

dur = e - s

puts dur

__END__


# Regex hang

text = <<TEXT
asdf <!-- OPTIONAL : State school colours, using words, then <br>then
                                         {{colorbox|#xxyyzz}}
TEXT

begin
status = Timeout::timeout(5) {
  text =~ /<!--(.|\s)*?-->/
}
rescue => e
  puts e
end

puts "asdfadfadf"
puts status