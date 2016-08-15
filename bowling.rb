class Game
  
  attr_accessor :score
  
  def initialize
    @score = 0
  end
  
  def roll(num)
    @score += num
  end
  
end