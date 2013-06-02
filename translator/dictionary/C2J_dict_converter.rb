#encoding: UTF-8

inFile = open('/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/translator/dictionary/zh_ja.txt')
content = inFile.read
inFile.close

outFile = File.open('/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/translator/dictionary/C2J.dic', 'w')

content.scan(/^(.*?)===$/m) do |comp|
  puts "***************"
  str = ""
  puts comp
  puts '---'
  pairs = comp[0].split(/^\[(?:.+)\]$/)
  
  word = pairs[0].strip
  meanings = pairs[1].strip
  puts "==[#{pairs}]"
  puts "==1: #{word}"
  puts "==2: #{meanings}"
  puts "---"
  str << "#" << word << "\\"
  
  meanings.gsub!(/[0-9]\./, "")
  meanings.gsub!(/（(.+?)）/, "")
  meanings.gsub!(/\[(.+?)\]/, "")
  meanings.gsub!("\n", ",")

  puts meanings
  puts '---'
  arr = meanings.split("．")
  arr.each do |m|
    str << "#{m.strip};"
  end
  str << "\n"
  puts str
  # gets
  
  outFile << str
end

outFile.flush
outFile.close