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
    raise RuntimeError, 'game is over.  no more rolls remain' if game_over?
    if @frames.length == 10
      @frames.last << num
      exceeds_pins?
    elsif @frames.length == 0 || @frames.last[0] == 10 || @frames.last.length == 2
      @frames << [num] #add to next one
    else
      raise RuntimeError if (num + @frames.last[0]) > 10
      @frames.last << num #add to current one
    end
  end
  
  def exceeds_pins?
    # if @frames.length == 10 && !(strike? || spare?)
    if @frames.last[2] && (@frames.last[1] < 10)
      raise RuntimeError if @frames.last[1] + @frames.last[2] > 10
    end
  end

  def score
    raise RuntimeError, 'game is not over' unless game_over?
    scored_frames = []
    @frames.each_with_index do |frame, index|
      if index == 9
        counter = frame_total(frame)
      elsif strike?(frame)
        arr = [frame_total(frame), (@frames[index + 1][0]), (@frames[index + 1][1] || @frames[index + 2][0]) ]
        counter = arr.compact.reduce(:+)
      elsif spare?(frame)
        counter = frame_total(frame) + @frames[index + 1][0]
      else
        counter = frame_total(frame)
      end
      scored_frames << counter
    end
    scored_frames.reduce(:+)
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