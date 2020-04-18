class Snake
  attr_reader :score, :alive

  SIZE = 10
  GRID_WIDTH  = 64
  GRID_HEIGHT = 48

  def initialize
    @beep = Gosu::Sample.new('media/beep.wav')
    @body_part = Gosu::Image.new('media/earth.png', rect: [0, 0, Snake::SIZE, Snake::SIZE])

    @x = (rand * (GRID_WIDTH - 4)).round
    @y = (rand * (GRID_HEIGHT - 4)).round
    @x_direction = 1
    @y_direction = 0

    @growth_rate = 1
    @grow_remaining = 0

    @body_queue = []
    @body_queue << {x: @x - 2, y: @y}
    @body_queue << {x: @x - 1, y: @y}
    @body_queue << {x: @x,     y: @y}

    @move_queue = []

    @score = 0
    @game_over = Gosu::Font.new(20)

    @alive = true
  end

  def turn_up
    return unless @y_direction == 0 # don't allow the snake to reverse into itself
    @move_queue.push({x_direction: 0, y_direction: -1})
  end

  def turn_down
    return unless @y_direction == 0 # don't allow the snake to reverse into itself
    @move_queue.push({x_direction: 0, y_direction: 1})
  end

  def turn_left
    return unless @x_direction == 0 # don't allow the snake to reverse into itself
    @move_queue.push({x_direction: -1, y_direction: 0})
  end

  def turn_right
    return unless @x_direction == 0 # don't allow the snake to reverse into itself
    @move_queue.push({x_direction: 1, y_direction: 0})
  end

  def move
    return unless @alive

    if @move_queue.size > 0
      q = @move_queue.pop
      @x_direction = q[:x_direction]
      @y_direction = q[:y_direction]
    end

    @x += @x_direction
    @y += @y_direction

    # "wrap around" the game window (start over at the opposite side)
    @x %= GRID_WIDTH
    @y %= GRID_HEIGHT

    # erase the tail unless we are still growing as a result of eating
    if @grow_remaining > 0
      @grow_remaining -= 1
    else
      @body_queue.shift
    end

    # die if we crash into ourselves
    @body_queue.each do |q|
      if @x == q[:x] and @y == q[:y]
        @alive = false
        break
      end
    end

    @body_queue << {x: @x, y: @y}
  end

  def draw
    @body_queue.each do |q|
      @body_part.draw(q[:x] * Snake::SIZE, q[:y] * Snake::SIZE, ZOrder::SNAKE)
    end

    if not @alive
      @game_over.draw_text_rel('GAME OVER',
                               GRID_WIDTH * Snake::SIZE / 2, GRID_HEIGHT * Snake::SIZE / 2 - 10, ZOrder::UI, 0.5, 0.5)
      @game_over.draw_text_rel("Press 'N' to start a new game or 'Esc' to exit",
                               GRID_WIDTH * Snake::SIZE / 2, GRID_HEIGHT * Snake::SIZE / 2 + 10, ZOrder::UI, 0.5, 0.5)
    end
  end

  def eat(food)
    if @x == food.x and @y == food.y
      @score += 10
      @beep.play
      @growth_rate += 2
      @grow_remaining += @growth_rate
      true
    else
      false
    end
  end
end