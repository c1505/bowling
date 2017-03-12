require 'pry'
#do
# fix top level constant warning
# refactor
  # FinalFrame
  #long conditional in roll


class Game
  class BowlingError < StandardError
  end

  def initialize
    @pins = 0
    @frames = [Frame.new]
  end

  def roll(pins)
    raise BowlingError if pins < 0 || pins > 10
    if @frames.last.closed?
      frame = if @frames.length == 9
                FinalFrame.new
              else
                Frame.new
              end
      @frames << frame
      frame.roll(pins)
    else
      @frames.last.roll(pins)
    end
  end

  def score
    unless @frames.count == 10 && @frames.last.closed?
      raise BowlingError, 'Game is not complete'
    end
    total = 0
    @frames[0..8].each_with_index do |frame, index|
      total += frame.score
      total += next_two_rolls(index) if frame.strike?
      total += @frames[index + 1].rolls[0] if frame.spare?
    end
    total += final_frame_score
  end

  private

  def final_frame_score
    @frames.last.score
  end

  def next_two_rolls(index)
    if @frames[index + 1].rolls.length >= 2
      @frames[index + 1].rolls[0] + @frames[index + 1].rolls[1]
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
    raise Game::BowlingError if @pins_remaining < 0
    @rolls << pins
  end

  def closed?
    @pins_remaining.zero? || @rolls_remaining.zero?
  end

  def score
    @rolls.reduce(:+)
  end

  def strike?
    @rolls_remaining == 1 && @pins_remaining.zero?
  end

  def spare?
    @rolls_remaining.zero? && @pins_remaining.zero?
  end
end

class FinalFrame < Frame
  # each finalframe could really have 3 frames within it in a way
  def initialize
    @rolls_remaining = 2
    @rolls = []
    @pins_remaining = 10
  end

  def roll(pins)
    @rolls_remaining -= 1
    @pins_remaining -= pins
    raise Game::BowlingError if @pins_remaining < 0
    @rolls << pins
    if strike? || spare?
      @pins_remaining = 10
      @rolls_remaining = 1
    end
  end

  def closed?
    @rolls.count == 3 || (@rolls.count == 2 && (@rolls[0] + @rolls[1] < 10))
  end
end
module BookKeeping
  VERSION = 3
end
