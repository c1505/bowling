module BookKeeping
  VERSION = 1
end

class Game
  
  attr_accessor :score
  attr_reader :frames
  
  
  def initialize
    @score = 0
    @frames = []
  end
  
  def roll(num)
    raise RuntimeError, 'not a valid roll' unless valid_roll?(num)
    raise RuntimeError if game_over?
    if @frames.length == 10
      @frames.last << num
      if @frames.last[2] && (@frames.last[1] < 10)
        raise RuntimeError if @frames.last[1] + @frames.last[2] > 10
      end
    elsif @frames.length == 0 || @frames.last[0] == 10 || @frames.last.length == 2
      @frames << [num] #add to next one
    else
      raise RuntimeError if (num + @frames.last[0]) > 10
      @frames.last << num #add to current one
    end
  end
  
  def score
    raise RuntimeError, 'game is not over' unless game_over?
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
  
    
  def spare?(frame) 
    (frame[0] + frame[1]) == 10
  end
  
  def strike?(frame) 
    frame[0] == 10
  end
  
  def game_over?
    result = false
    if @frames.length >= 10 && @frames.last.length == 2
      unless spare?(@frames.last) || strike?(@frames.last)
        result = true
      end
    elsif @frames.length >= 10 && @frames.last.length == 3
      result = true
    else
      result = false
    end
    result
  end
  
# @game.frames.length >= 10 && @game.frames.last.length == 2
  
  def valid_roll?(num)
    num >= 0 && num <= 10 
  end
    


# 105.0: flog total
#     13.1: flog/method average

#     54.9: Game#score                       bowling.rb:54
#     24.2: Game#roll                        bowling.rb:15

  
end