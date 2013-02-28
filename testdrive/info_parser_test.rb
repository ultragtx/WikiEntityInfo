require_relative '../parser/info_parser'

infobox = <<TEXT
{{基礎情報 会社
|社名=株式会社ニワンゴ
|英文社名=niwango,inc.
|ロゴ=[[画像:Niwango logo.png|167px]]
|種類=[[株式会社]]
|市場情報=
|略称=
|国籍={{JPN}}
|本社郵便番号=
|本社所在地=[[東京都]][[渋谷区]][[神宮前]]一丁目15番2号<br/>ニコニコ本社ビル
|設立=[[2005年]][[11月14日]]
|業種=情報・通信業
|統一金融機関コード=
|SWIFTコード=
|事業内容=携帯電話メールによるコンテンツ・情報配信サービスの企画・制作・運営および動画投稿共有サイトの運営等
|代表者=[[川上量生]]（[[代表取締役]][[会長]]）<br />[[杉本誠司]]（代表取締役[[社長]]）
|資本金=9000万円（2010年9月30日時点）
|発行済株式総数=
|売上高=
|営業利益=
|純利益=9156万4000円（2010年9月期）
|純資産=1129万7000円（2010年9月30日時点）
|総資産=4400万円（2010年9月30日時点）
|従業員数=
|決算期=[[9月30日|9月末日]]
|主要株主=[[ドワンゴ]] 75.1%<br />[[未来検索ブラジル]] 19.9%<br/>[[CELL]] 5%
|主要子会社=
|関係する人物=[[西村博之]]（元[[取締役]]）
|外部リンク=http://niwango.jp/
|特記事項=[[ドワンゴ]]の系列企業
}}
TEXT

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


parser = InfoParser.new("ja")
useful_type, infobox_type, infobox_properties = parser.get_infobox(infobox)
 
puts infobox_properties.to_s