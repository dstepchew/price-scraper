require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.patagonia.com/us/product/mens-lightweight-synchilla-snap-t?p=25580-0"
doc = Nokogiri::HTML(open(url))
doc.css("midPageRightCol").each do |item|
  text = item.at_css("prodname").text
  price = item.at_css("price").text[/\$[0-9\.]+/]
  puts "#{text} - #{price}"
end