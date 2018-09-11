class Leafgem::Window
  property window : SDL::Window
  property size = NewVec2(Int32).new 0, 0

  def initialize(title, width, height, resize)
    @window = SDL::Window.new(
      title, width, height,
      LibSDL::WindowPosition::UNDEFINED,
      LibSDL::WindowPosition::UNDEFINED,
      (resize) ? LibSDL::WindowFlags::RESIZABLE : LibSDL::WindowFlags::SHOWN)

    @size = NewVec2.from width, height
  end

  def current_size
    cr_w = 0
    cr_h = 0
    LibSDL.get_window_size(@window, pointerof(cr_w), pointerof(cr_h))
    NewVec2.from cr_w, cr_h
  end
end
