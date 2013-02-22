# encoding: utf-8

require 'nokogiri'
require 'open-uri'

CAT_ROOT = "http://zh.wikipedia.org/wiki/Category:"
MAX_DEPTH = 100
DONE = []
IGNORE = []
PATH = "/Users/ultragtx/DevProjects/Ruby/WikipediaEntityAnalyser2/categories/"

def remove_new_lines(text)
  text.gsub('\n', ' ')
end

def fetch_content(link, dest)
  if !File.exist?(dest) || File.size(dest) == 0
    remote = open(URI::encode(link), 'User-Agent' => 'ruby')
    data = remote.read
    remote.close
    
    file = File.new(dest, 'w+')
    file.binmode
    file << data
    file.flush
    file.close
  else
    local = open(dest)
    data = local.read
    local.close
  end
  data
end

def all_bullets(content)
  doc = Nokogiri::HTML(content)
  bullets = []
  empty_bullets = []
  
  doc.xpath("//div[@class='CategoryTreeItem']").each do |node|
    # puts node
    sub_doc = Nokogiri::HTML(node.to_s)
    if sub_doc.xpath("//span[@class='CategoryTreeBullet']").count > 0
      # puts '@' + sub_doc.xpath("//a")[0].inner_text.gsub(' ', '_')
      bullets << sub_doc.xpath("//a")[0].inner_text.gsub(' ', '_')
    elsif sub_doc.xpath("//span[@class='CategoryTreeEmptyBullet']").count > 0
      # puts '#' + sub_doc.xpath("//a")[0].inner_text.gsub(' ', '_')
      empty_bullets << sub_doc.xpath("//a")[0].inner_text.gsub(' ', '_')
    end
    # puts '-------------'
  end
  
  return empty_bullets, bullets
end

def print_tree(cat_name, count)
  if count == MAX_DEPTH
    puts "$$$$$$$$MAX DEPTH REACH$$$$$$$$$"
    return
  end
  
  cat_name.gsub!("\\'", "'")
  
  content = fetch_content(CAT_ROOT + cat_name, PATH + cat_name + ".html")
  empty_bullets, bullets = all_bullets(content)
  
  empty_bullets.each do |empty_bullet|
    printf "  " * count
    # fetch_content(CAT_ROOT + empty_bullet, PATH + empty_bullet + ".html")
    puts empty_bullet
  end
  
  bullets.each do |bullet|
    printf "  " * count
    puts bullet
    if DONE.include?(bullet)
      puts "Done..." + bullet
    else
      DONE << bullet
      print_tree(bullet, count + 1)
    end
  end
end
  
print_tree('各国公司', 0)

__END__

puts 'test'
puts fetch_content(CAT_ROOT + '各国公司', PATH + '各国公司.html')