require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.patagonia.com/us/product/mens-better-sweater-and-quarter-zip-fleece-pullover?p=25521-0&pcc=1128"
doc = Nokogiri::HTML(open(url))
description = doc.at_css("#prodname h1").text
price = doc.at_css("#price").text
puts "#{description} - #{price}"