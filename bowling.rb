require 'pry'
class Game
  
  attr_accessor :score
  attr_reader :frames
  attr_reader :to_frames
  
  
  def initialize
    @score = 0
    @all_rolls = []
  end
  
  def roll(num)
    @all_rolls << num
  end
  
  # the last frame needs to be a special case in a different way.  each frame
  # make into a nested array instead
  def score
    new_frames = []
    @all_rolls.each_with_index do |score, index|
      counter = 0
      if frame_count == index + 1
        
      elsif strike?(score)
        arr = [score, (@all_rolls[index + 1]), (@all_rolls[index + 2]) ]
        counter = arr.compact.reduce(:+)
      elsif spare?(score, index)
          counter = score + @all_rolls[index + 1]
      else
        counter = score
      end
      new_frames << counter
    end
    new_frames.reduce(:+)
  end
  
  def frame_count
    count = 0
    @all_rolls.each do |roll|
      if roll == 10
        count += 1
      else
        count += 0.5
      end
    end
    count
  end
    
      
      
  def strike?(score)
    score == 10
  end
  
  def spare?(score, index)
    !strike?(score) && @all_rolls.length.even? && @all_rolls.length > 1 && ( (score + @all_rolls[index - 1]) == 10 ) 
  end
  
# 10 for the pins actually knocked down in that frame when a strike is rolled, 
# plus 10 pins for the first roll that follows (which would have to be a strike),
# and another 10 pins for the second roll (which would also have to be a strike).
    

  
end