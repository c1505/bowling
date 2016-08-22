# game has 10 frames

# should the game or frame know about a strike?
require 'pry'


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
  # the actual difference is in the scoring and that there is an extra roll
  def strike?
    false
  end

  def spare?
    false
  end

  def over?
    @points.length == 3 || (@points.length == 2 && @pins < 10)
  end

  def roll(pins)
    @rolls_remaining -= 1
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
    @frames.map.with_index do |frame, index|
      if frame.strike?
        frame.point_total + next_two_rolls(index)
      elsif frame.spare?
        frame.point_total + @frames[index + 1].points[0]
      else
        frame.point_total
      end
    end.reduce(:+)
  end

  def next_two_rolls(index)
    @frames[index + 1].points[0] + (@frames[index + 1].points[1] || @frames[index + 2].points[0])
  end


end

module BookKeeping
  VERSION = 1
end