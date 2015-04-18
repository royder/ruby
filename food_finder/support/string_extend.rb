# Example of adding a method to the Ruby String class
class String
  
  # Ruby already has a capitalize method which will capitalize each
  # word of a string.  This is our own method to apply this to all words
  # in a string.
  def titleize
    self.split(' ').collect {|word| word.capitalize}.join(' ')
  end
end