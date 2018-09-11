require "../../src/leafgem"
include Leafgem::Library

class Draggable < Leafgem::Shapes::Rectangle
  def initialize
    super
    @offset_x = 0_f64
    @offset_y = 0_f64
    @fill_colour = {33, 33, 33, 255}
  end

  def init
    @pos.x = 32
    @pos.y = 32
    @size.x = 32
    @size.y = 32
  end

  def update
    if Mouse.scroll.up?
      @size += 2
    elsif Mouse.scroll.down?
      @size -= 2
    end

    # If Mouse.primary exists (and thus is active)
    if primary = Mouse.primary
      x = Mouse.position.not_nil!.x.to_f
      y = Mouse.position.not_nil!.y.to_f
      if point_in?(x, y) && @dragging
        Mouse.cursor = "pointer"
      end

      # If it's been held
      if primary.held? && @dragging
        @fill_colour = {127, 33, 33, 255}

        # Get the positions
        # Set self to mouse poition
        @pos.x = x + @offset_x
        @pos.y = y + @offset_y
        # If it's the first tap
      elsif primary.pressed?
        # If click starts out in self
        # So the rect of logic won't trigger if you move the mouse over it
        @dragging = true if point_in? x, y

        # Offsets so it stays relatively positioned to where you clicked
        @offset_x = @pos.x - x
        @offset_y = @pos.y - y
      end
      # Update primary click
      # primary.update
    else
      @fill_colour = {33, 33, 33, 255}
      @dragging = false
      Mouse.cursor = nil
    end
  end

  def draw
    # note that the "draw" color is always white until set otherwise
    set_draw_color(@fill_colour)
    draw_self
  end
end

set_window("Leafgem Mouse Example!", 560, 400, 1)
create_object(Draggable, 0, 0)

Leafgem::Game.run
