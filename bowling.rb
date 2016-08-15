require 'pry'
class Game
  
  attr_accessor :score
  
  def initialize
    @score = 0
    @frames = []
  end
  
  def roll(num)
    @frames << num
  end
  
  def score
    new_frames = []
    @frames.each_with_index do |score, index|
      counter = 0
      if score == 10
        counter = score + (@frames[index + 1]) + (@frames[index + 2])
      elsif @frames.length.even? && @frames.length > 1
        if (score + @frames[index - 1]) == 10
          counter = score + @frames[index + 1]
        else
          counter = score
        end
      else
        counter = score
      end
      new_frames << counter
    end
    new_frames.reduce(:+)
  end
# 10 for the pins actually knocked down in that frame when a strike is rolled, 
# plus 10 pins for the first roll that follows (which would have to be a strike),
# and another 10 pins for the second roll (which would also have to be a strike).
    

  
end