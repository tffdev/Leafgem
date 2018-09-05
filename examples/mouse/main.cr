require "../../src/leafgem"

class Draggable < Leafgem::Object
  def initialize
    super
    @offset_x = 0_f64
    @offset_y = 0_f64
    @fill_colour = {33, 33, 33, 255}
  end

  def init
    @x = 32
    @y = 32
    @w = 32
    @h = 32
  end

  def update
    # If Mouse.primary exists (and thus is active)
    if primary = Mouse.primary
      # If it's been held
      if primary.held? && @dragging
        @fill_colour = {127, 33, 33, 255}

        # Get the positions
        x = Mouse.position.not_nil!.x.to_f
        y = Mouse.position.not_nil!.y.to_f
        # Set self to mouse poition
        @x = x + @offset_x
        @y = y + @offset_y
        # If it's the first tap
      elsif primary.pressed?
        x = Mouse.position.not_nil!.x.to_f
        y = Mouse.position.not_nil!.y.to_f

        # If click starts out in self
        # So the rect of logic won't trigger if you move the mouse over it
        @dragging = true if point_in? x, y

        # Offsets so it stays relatively positioned to where you clicked
        @offset_x = @x - x
        @offset_y = @y - y
      end
      # Update primary click
      primary.update
    else
      @fill_colour = {33, 33, 33, 255}
      @dragging = false
    end
  end

  def draw
    # Set self colour
    Leafgem::Renderer.renderer.draw_color = SDL::Color.new(*@fill_colour)

    # draw_rect & fill_rect in library have bugs that make them not suitable for this
    Leafgem::Renderer.renderer.fill_rect(@x.to_i, @y.to_i, @w.to_i, @h.to_i)
  end
end

set_window("Leafgem Mouse Example!", 560, 400, 1, true)
create_object(Draggable, 0, 0)

Leafgem::Game.run
