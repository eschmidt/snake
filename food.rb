class Food
  attr_reader :x, :y

  SIZE = 10

  def initialize
    @x = (rand * 63).round
    @y = (rand * 47).round
  end

  def draw
    image.draw_rot(@x * Food::SIZE + Food::SIZE / 2, @y * Food::SIZE + Food::SIZE / 2, ZOrder::FOOD,
                   25 * Math.sin(Gosu.milliseconds / 133.7))
  end

  private

  def image
    @@image ||= Gosu::Image.new('media/gem.png', rect: [0, 0, Food::SIZE, Food::SIZE])
  end
end