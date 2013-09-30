require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'rest-open-uri'
require 'selenium-webdriver'

AUTH_URL          = 'https://accounts.coursera.org/signin'

def scrapera
  puts "Enter coursera email address \n"
  @email = gets.chomp
  puts "Enter coursera password \n"
  @password = gets.chomp

  #setup selenium firefox profile download settings
  fp = Selenium::WebDriver::Firefox::Profile.new
  fp['browser.download.manager.showWhenStarting'] = false
  fp['browser.download.folderList'] = 2
  fp['browser.download.defaultFolder'] = File.expand_path $0
  fp['browser.helperApps.neverAsk.saveToDisk'] = "video/mp4:MPEG-4"

  #log in to coursera with supplied credentials
  driver = Selenium::WebDriver.for :firefox, :profile => fp
  driver.get AUTH_URL

  sleep(3)

  email_element = driver.find_element(:id,'signin-email')
  password_element = driver.find_element(:id,'signin-password')

  email_element.send_keys @email
  password_element.send_keys @password

  password_element.submit

  sleep(10)

  #obtain list of currently enrolled classes
  course_elements = driver.find_elements(:css, ".coursera-course-listing-name a")


  courses = Hash.new
  count = 0

  course_elements.each do |course|
    count += 1
    courses[count] = course.text()
  end

  #list enrolled courses
  courses.each do |key, value|
    puts "#{key} - #{value} \n"
  end

  #obtain course to download from user
  puts "Enter the number of the course that you would like to download \n"
  course_number = gets.chomp.to_i

  #obtain url for selected class
  course_url = course_elements[course_number].attribute("href")
  
  #navigate to lectures index
  driver.navigate.to course_url
  lectures_url = driver.find_element(:link,"Video Lectures").attribute("href")
  driver.navigate.to lectures_url

  #obtain all video urls
  video_elements = driver.find_elements(:xpath,"//a[@title='Video (MP4)']")

  video_elements.each do |video|
     driver.get video.attribute('href')
     sleep(20)
     puts "downloaded #{video.attribute('href')}"
  end
end

