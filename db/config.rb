require 'active_record'

puts "#{File.dirname(__FILE__)}/../db/confessions.sqlite3"
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "#{File.dirname(__FILE__)}/../db/confessions.sqlite3")
