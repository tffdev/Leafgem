class Leafgem::Window
  property window : SDL::Window
  @size = Vec2.new(0, 0)

  def initialize(title, width, height, resize)
    @window = SDL::Window.new(
      title, width, height,
      LibSDL::WindowPosition::UNDEFINED,
      LibSDL::WindowPosition::UNDEFINED,
      (resize) ? LibSDL::WindowFlags::RESIZABLE : LibSDL::WindowFlags::SHOWN)

    @size = Vec2.new(width, height)
  end

  def current_size
    cr_w = 0
    cr_h = 0
    LibSDL.get_window_size(@window, pointerof(cr_w), pointerof(cr_h))
    Vec2.new(cr_w, cr_h)
  end

  def window
    @window
  end

  def size
    @size
  end

  def width
    @size.x
  end

  def height
    @size.y
  end
end
