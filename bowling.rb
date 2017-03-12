require 'pry'
class Game
  def initialize
    @pins = 0
    @frames = [Frame.new]
  end

  def roll(pins)
    if @frames.last.closed?
      frame = Frame.new
      @frames << frame
      frame.roll(pins)
    else
      @frames.last.roll(pins)
    end
  end

  def score
    total = 0
    @frames.each_with_index do |frame, index|
      total += frame.score
      # total += frame.next if frame.strike?
      total += @frames[index + 1].score if frame.strike?
      if frame.spare?
        total += @frames[index + 1].rolls[1]
      end
    end
    total
  end

end

class Frame
  attr_reader :rolls
  def initialize
    @pins_remaining = 10
    @rolls_remaining = 2
    @rolls = []
  end

  def roll(pins)
    @rolls_remaining -= 1
    @pins_remaining -= pins
    @rolls << pins
  end

  def closed?
    @pins_remaining == 0 || @rolls_remaining == 0
  end

  def score
    @rolls.reduce(:+)
  end

  def strike?
    @rolls_remaining == 1 && @pins_remaining == 0
  end

  def spare?
    @rolls_remaining == 0 && @pins_remaining == 0
  end

end
