require 'number_helper'
class Restaurant
  include NumberHelper

  #Class variables
  @@filepath = nil
  @@restaurants = []
  
  #Class writer method
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end
  
  attr_accessor :name, :cuisine, :price
  
  # This is just an example, see file_usable
  def self.file_exists?
    !@@filepath && File.exists?(@@filepath)
  end

  # Instead of example in file_exists?, you could use the following return unless
  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end
  
  # Create the file with open unless it already exists
  def self.create_file
    File.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end
  
  # Read saved restaurants from file.  
  def self.saved_restaurants

    #Used cached results for subsequent calls
    if !@@restaurants.empty?
      return @@restaurants
    end
    
    if file_usable?
      File.open(@@filepath, 'r') {|file|
        file.each_line {|line| 
          @@restaurants << Restaurant.new.import_line(line.chomp)
        }
      }
    end
    @@restaurants
  end
  
  def self.build_using_questions
    args = {}
    print 'Restaurant Name: '
    args[:name] = gets.chomp.strip
    
    print 'Cuisine Type: '
    args[:cuisine] = gets.chomp.strip
    
    print 'Average Price: '
    args[:price] = gets.chomp.strip
    
    self.new(args)
  end

  # Set instance attributes or use empty string if nil
  def initialize(args={})
    @name = args[:name] || ""
    @cuisine = args[:cuisine] || ""
    @price = args[:price] || ""
  end
  
  def import_line(line)
    line_array = line.split("\t")
    @name, @cuisine, @price = line_array
    return self
  end
  
  def save
    return false unless Restaurant.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
    end
    true
  end
  
  def formatted_price
    number_to_currency(@price)
  end
  
end