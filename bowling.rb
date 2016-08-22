class Frame
  attr_reader :points
  def initialize
    @pins = 10
    @rolls_remaining = 2
    @points = []
  end

  def over?
    @pins == 0 || @rolls_remaining == 0
  end

  def roll(pins)
    raise RuntimeError, 'Pin count exceeds pins on the lane' if (@pins - pins) < 0
    @rolls_remaining -= 1
    @pins -= pins
    @points << pins
  end

  def strike?
    @rolls_remaining == 1 && @pins == 0
  end

  def spare?
    @rolls_remaining == 0 && @pins == 0
  end

  def point_total
    @points.reduce(:+)
  end

end

class FinalFrame < Frame
  def over?
    @points.length == 3 || (@points.length == 2 && @pins > 0)
  end

  def exceeds_pins?(pins)
    if points[1] && points[1] < 10
      if points[1] + pins > 10
        raise RuntimeError, 'Pin count exceeds pins on the lane' 
      end
    end
  end

  def roll(pins)
    exceeds_pins?(pins)
    @pins -= pins
    @points << pins
  end
end

class Game
  attr_reader :score
  attr_reader :frames
  def initialize
    @score = 0
    @frames = [Frame.new]
  end

  def roll(pins)
    raise RuntimeError, 'Pins must have a value from 0 to 10' if pins < 0 || pins > 10
    raise RuntimeError, 'Should not be able to roll after game is over' if game_over?
    if @frames.last.over?
      if @frames.length < 9
        @frames << Frame.new
      else
        @frames << FinalFrame.new
      end
    end
    @frames.last.roll(pins)
  end

  def score
    raise RuntimeError, 'Score cannot be taken until the end of the game' unless game_over?
    @frames[0..8].map.with_index do |frame, index|
      if frame.strike?
        frame.point_total + next_two_rolls(index)
      elsif frame.spare?
        frame.point_total + @frames[index + 1].points[0]
      else
        frame.point_total
      end
    end.reduce(:+) + @frames.last.point_total
  end

  def next_two_rolls(index)
    @frames[index + 1].points[0] + (@frames[index + 1].points[1] || @frames[index + 2].points[0])
  end

  def game_over?
    @frames.length == 10 && @frames.last.over?
  end

end

module BookKeeping
  VERSION = 1
end