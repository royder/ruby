#### Food Finder ####
#
# Launch this Ruby file from the command line
# to get started.
#
 
 APP_ROOT = File.dirname(__FILE__)
 
 # require File.join(APP_ROOT, 'lib', 'guide')
 
 $:.unshift(File.join(APP_ROOT, 'lib'))
 $:.unshift(File.join(APP_ROOT, 'support'))
 require 'guide'
 
 guide = Guide.new('restaurants.txt')
 guide.launch!