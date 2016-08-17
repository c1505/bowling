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
    # in a real game, i would decide the end of the frame after the roll.  here i am deciding at the beginning of the next roll
    raise RuntimeError, 'not a valid roll' unless valid_roll?(num) #should valid roll include idea of too many pins?
    raise RuntimeError, 'game is over.  no more rolls remain' if game_over?
    exceeds_pins?(num)
  
    if @frames.length == 10
      @frames.last << num
    elsif @frames.length == 0 || strike?(@frames.last) || @frames.last.length == 2
      @frames << [num] #add to next one
    else
      @frames.last << num #add to current one
    end
  end
  
  def exceeds_pins?(num=0)
    return unless @frames.last && @frames.last[0]
    if @frames.length == 10 && @frames.last[1] && (num < 10) 
      raise RuntimeError, 'last frame exceeds pin count' if num + @frames.last[1] > 10
    elsif (num + @frames.last[0]) > 10 && !strike?(@frames.last)
      raise RuntimeError, 'normal frame exceeds pin count'
    end
  end

  def score
    raise RuntimeError, 'game is not over' unless game_over?
    @frames.map.with_index do |frame, index|
      if index == 9
        frame_total(frame)
      elsif strike?(frame)
        frame_total(frame) + strike_score(index)
      elsif spare?(frame)
        frame_total(frame) + @frames[index + 1][0]
      else
        frame_total(frame)
      end
    end.reduce(:+)
  end
  
  def strike_score(index)
    arr = [(@frames[index + 1][0]), (@frames[index + 1][1] || @frames[index + 2][0]) ]
    arr.compact.reduce(:+)
  end

  def frame_total(frame)
    frame.reduce(:+)
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
  
  def valid_roll?(num)
    num >= 0 && num <= 10 
  end
    

end