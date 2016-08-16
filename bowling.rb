require 'pry'
class Game
  
  attr_accessor :score
  attr_reader :frames
  attr_reader :to_frames
  
  
  def initialize
    @score = 0
    @all_rolls = []
    @frames = []
  end
  
  def roll(num)
    @all_rolls << num

    if @frames.length == 10
      @frames.last << num
    elsif @frames.length == 0 || @frames.last[0] == 10 || @frames.last.length == 2
      @frames << [num] #add to next one
    else 
      @frames.last << num #add to current one
    end
  end
  
    def score
      new_frames = []
      @frames.each_with_index do |frame, index|
        if index == 9
          counter = frame.reduce(:+)
        elsif strike?(frame)
          arr = [frame[0], (@frames[index + 1][0]), (@frames[index + 1][1] || @frames[index + 2][0]) ]
          counter = arr.compact.reduce(:+)
        elsif spare?(frame)
          counter = frame[0] + frame[1] + @frames[index + 1][0]
        else
          counter = frame[0] + frame[1]
        end
        new_frames << counter
      end
      new_frames.reduce(:+)
    end
  
  def frame_count
    count = 0
    @all_rolls.each do |roll|
      return count if count == 10
      if roll == 10
        count += 1
      else
        count += 0.5
      end
    end
    count
  end
    
  
  def spare?(frame) #second implementation
    (frame[0] + frame[1]) == 10
  end
  
  def strike?(frame) #second implementation
    frame[0] == 10
  end


# 105.0: flog total
#     13.1: flog/method average

#     54.9: Game#score                       bowling.rb:54
#     24.2: Game#roll                        bowling.rb:15

  
end