require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.medelita.com/lab-coat-38-estie.html"
doc = Nokogiri::HTML(open(url))
doc.css(".Item").each do |item|
  title = item.at_css("h1").text
  price = item.at_css("#ItemSelectPrice").text[/\$[0-9\.]+/]
  puts "#{title} - #{price}"
end