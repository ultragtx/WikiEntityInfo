#encoding: UTF-8

inFile = open('/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/translator/dictionary/jp_en.txt')
content = inFile.read
inFile.close

outFile = File.open('/Users/ultragtx/DevProjects/Ruby/WikiEntityInfo/translator/dictionary/J2E.dic', 'w')


content.scan(/^(.*?)$/) do |line|
  str = ""
  line = line[0]
  puts line
  puts '---'
  pairs = line.split('|||')
  
  word = pairs[0]
  meanings = pairs[1]
  
  str << "##{word}\\"
  
  arr = meanings.split(' ')
  arr.each do |meaning|
    puts meaning
    meaning.gsub!('_', " ")
    meaning.strip!
    str << "#{meaning};"
  end
  
  str << "\n"
  
  puts "---"
  puts str
  
  # gets
  
  outFile << str
end


outFile.flush
outFile.close