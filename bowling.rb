require 'pry'
class Game
  def initialize
    @pins = 0
    @frames = [Frame.new]
  end

  def roll(pins)
    if @frames.last.closed?
      if @frames.length == 8
        frame = FinalFrame.new
        @frames << frame
        frame.roll(pins)
      else
        frame = Frame.new
        @frames << frame
        frame.roll(pins)
      end
    else
      @frames.last.roll(pins)
    end
  end

  def score
    total = 0
    @frames[0..8].each_with_index do |frame, index|
      total += frame.score
      if frame.strike?
        total += next_two_rolls(index)
      end
      if frame.spare?
        total += @frames[index + 1].rolls[0]
      end
    end
    total += final_frame_score
  end

  private

  def final_frame_score
    @frames.last.score
  end

  def next_two_rolls(index)
    if @frames[index + 1].rolls.length == 2
      @frames[index + 1].score
    else
      @frames[index + 1].score + @frames[index + 2].rolls[0]
    end
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

class FinalFrame < Frame
  def initialize
    @rolls_remaining = 3
    @rolls = []
    @pins_remaining = 30
  end
end
