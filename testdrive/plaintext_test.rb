# encoding: utf-8

require 'nokogiri'


my_html = <<TEXT
 <p><img src="http://upload.wikimedia.org/wikipedia/zh/b/b1/Chinamobile.png" onerror="this.src='http://upload.wikimedia.org/wikipedia/zh/b/b1/Chinamobile.png';" alt="" title="" style="width:175px"></p>
TEXT

doc = Nokogiri::HTML(my_html)
doc.css("br").each { |node| node.replace("\n") }
puts doc.text