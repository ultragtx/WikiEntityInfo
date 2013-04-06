# encoding: utf-8

require 'nokogiri'


my_html = <<TEXT
<p>profit  CNY link:yes 2.003 trillion  (2011)<sup class="reference" id="cite_ref-FY_1-0">[<a href="#cite_note-FY_1">1</a>]</sup></p>
TEXT

puts Nokogiri::HTML(my_html).text