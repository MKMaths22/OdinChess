# frozen-string-literal: true

# IllegalMoveCount class simply keeps count of how many times there has been an illegal move 
# attempted. This can be good for testing purposes.
class IllegalMoveCount
  
  attr_accessor :counter
  
  def initialize
    @counter = 0
  end

  def increment_counter
    self.counter = @counter + 1
  end

  def report_count
    @counter
  end
end