require_relative '../parser/body_utils'

include InfoGetter

infobox = <<TEXT
{{Infobox_Company |
 company_name_zh =中国移动有限公司|
 company_name =中国移动有限公司|
 company_logo =[[File:Chinamobile.png|175px]]|
 company_type =[[上市公司]]|
 market_information ={{sehk|0941}}<br />{{nyse|CHL}}|
 company_slogan =沟通从心开始；移动信息专家；正德厚生 臻于至善|
 foundation =[[1997年]][[9月3日]]|
 location =[[中国]][[北京市]][[西城区]]金融街29号|
 industry =[[電訊]]|
 key_people =公司[[总经理]]：[[李跃]]|
 sales = 电信网络运营、電信增值服務|
 profit ={{increase}}1259億元人民幣(2011年)|
 asset =5634.93億元人民幣(2007年)|
 market_value =約15595億港元(2008年12月31日)|
 num_employees =145954人(截止2009年末)|
 products =|
 revenue ={{increase}}5280億元人民幣(2011年)|
 homepage = 10086.cn|
}}
TEXT

useful_type, infobox_type, infobox_properties = get_infobox(infobox)
 
puts infobox_properties.to_s