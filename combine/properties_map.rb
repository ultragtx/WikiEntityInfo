#encoding: UTF-8

class PropertiesMap
  attr_accessor :properties_map
  attr_accessor :langs_count
  
  def initialize(file_path, langs_order)
    self.properties_map = [];
    self.langs_count = -2
    
    @langs_order = langs_order
    
    read_file(file_path)
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
      
      if @langs_order.uniq.count != self.langs_count
        raise "Number of langs and order mismatch"
      end
      
      langs_properties = Array.new(cnt)
      
      comps[0..-2].each_with_index do |properties, index|
        properties_arr = properties.split(',')
        properties_arr.each do |property|
          property.strip!
        end
        langs_properties[@langs_order[index]] = properties_arr
      end
      
      trans = comps[-1].strip == 'T' ? true : false
      langs_properties[-1] = trans
      
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