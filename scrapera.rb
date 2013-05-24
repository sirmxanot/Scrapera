require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("https://www.coursera.org/maestro/api/user/login"))
