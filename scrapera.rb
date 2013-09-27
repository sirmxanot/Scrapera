require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'rest-open-uri'

AUTH_URL          = 'https://accounts.coursera.org/signin'
CLASS_URL         = 'https://class.coursera.org/#{@class_name}'

class Session
  def initialize(email, password, class_name)
    #attr_accessor session

    @email = email
    @password = password
    @class_name = class_name

    agent = Mechanize.new

    agent.get(AUTH_URL) do |signin|
      courses = signin.form_with(:class => 'coursera-signin-form') do |form|
        email_field = form.field_with(:id => 'signin-email')
        password_field = form.field_with(:id => 'signing-password')

        email_field.value = @email
        password_field.value = @password
      end.submit
    end

    puts dashboard
    #response = open(AUTH_URL, :method => :put, :http_basic_authentication => [@username, @password])

    
  end

end

class Class
  
end

