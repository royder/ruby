require 'restaurant'
require 'string_extend'
class Guide

  # A bit of an overkill, just trying out a class within a class
  # valid actions with reader class method
  class Config
    @@actions = ['list','find','add','quit']
    def self.actions; @@actions; end
  end

  # "Constructor" method for Ruby...
  # First see if you can use the file, otherwise create the file
  # if that fails then exit, could be a file permissions issue.
  def initialize(path=nil)
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Found restaurant file."
    elsif Restaurant.create_file
      puts "Created restaurant file."
    else
      puts "Exiting.\n\n"
      exit!
    end
  end

  def launch!
    introduction
    # action loop
    #   what do you want to do?
    #   do that action
    # repeat until user quits
    # Could use loop do with a break if result == :quit, not as clean
    result = nil
    until result == :quit
      action, args = get_action
      result = do_action(action, args)
    end
    conclusion
  end
  
  # Loop checking user input against valid list of actions
  def get_action
    action = nil
    until Guide::Config.actions.include?(action)
      puts "Actions: #{Guide::Config.actions.join(', ')}" if action
      print '> '
      user_response = gets.chomp.downcase.strip.split(' ')
      action = user_response.shift
      args = user_response
    end
    return action, args
  end
  
  # Perform action user selected
  def do_action(action, args=[])
    case action
    when 'list'
      list(args)
    when 'find'
      keyword = args.shift
      find(keyword)
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "\nI don't understand that command.\n"
    end
  end
  
  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)
    
    output_action_header('listing restaurants')
    
    restaurants = Restaurant.saved_restaurants
    restaurants.sort! {|r1,r2| 
      case sort_order
      when 'name'
        r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
        r1.cuisine.downcase <=> r2.cuisine.downcase
      when 'price'
        r1.price.to_i <=> r2.price.to_i
      end
    }
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine' or 'list by cuisine'\n\n"
  end
  
  def find(keyword='')
    output_action_header('find a restaurant')
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select {|rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) || 
        rest.price.to_i <= keyword.to_i 
      }
      output_restaurant_table(found)
    else
      puts "Find using a key phrase to search the restaurant list."
      puts "Examples: 'find tamale', 'find Mexican', 'find mex'\n\n"
    end
  end
  
  def add
    output_action_header('add a restaurant')
    restaurant = Restaurant.build_using_questions
    if restaurant.save
      puts "\nRestaurant Added\n\n"
    else
      puts "\nSave Error: Restaurant not added\n\n"
    end
  end
  
  def introduction
    puts "\n\n<<< Welcome to the Food Finder >>>\n\n"
    puts "This is an interactive guide to help you find the food you crave.\n\n"
  end
  
  def conclusion
    puts "\n<<< Goodbye >>>\n\n\n"
  end
  
  private
  
  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end
  
  def output_restaurant_table(restaurants=[])
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    print " " + "Price".ljust(6) + "\n"
    puts "-" * 60
    restaurants.each {|rest|
      line = " " + rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.formatted_price.rjust(6)
      puts line
    }
    puts "No listings found" if restaurants.empty?
    puts "-" * 60
  end
  
end
