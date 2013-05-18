#encoding: UTF-8

class PropertiesMap
  attr_accessor :properties_map
  attr_accessor :langs_count
  
  def initialize(file_path)
    self.properties_map = [];
    self.langs_count = -2
    self.read_file(file_path)
  end

  def read_file(file_path)
    file = open(file_path)
    content = file.read
    
    content.scan(/^(.*?)$/) do |line|
      line = line[0]
      comps = line.split('|')
      cnt = comps.count
      if self.langs_count != -2 && cnt - 1 != self.langs_count
        raise "Input file error"
      end
      
      self.langs_count = cnt - 1
      
      trans = true
      langs_properties = []
      
      comps.each_with_index do |str, index|
        if index != cnt - 1
          properties_arr = str.split(',')
          properties_arr.each do |property|
            property.strip!
          end
          langs_properties << properties_arr
        else
          trans = str.strip == 'T' ? true : false
          langs_properties << trans
        end
      end
      
      self.properties_map << langs_properties
    end
  end
  
  def to_s
    puts "langs count: #{langs_count}"
    self.properties_map.each do |property_map|
      cnt = property_map.count
      property_map.each_with_index do |comp, index|
        if index != cnt - 1
          printf "#{comp}"
          printf ' | '
        else
          printf "#{comp}\n"
        end
      end
    end
  end
end