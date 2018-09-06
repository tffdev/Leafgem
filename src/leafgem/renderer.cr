module Leafgem::Renderer
  @@fps = 60
  @@renderer : SDL::Renderer?
  @@window : SDL::Window?

  @@scale = 1

  @@width = 0.0
  @@height = 0.0
  @@window_current_width = 0.0
  @@window_current_height = 0.0

  @@camera = Leafgem::Camera.new

  @@draw_offset_x = 0.0
  @@draw_offset_y = 0.0

  def create(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32)
    # Create window
    @@window = SDL::Window.new(window_title, window_width, window_height, LibSDL::WindowPosition::UNDEFINED, LibSDL::WindowPosition::UNDEFINED, LibSDL::WindowFlags::RESIZABLE)
    @@scale = pixel_scale

    # Create renderer
    if (window = @@window)
      @@width = (window.width / pixel_scale).to_f
      @@height = (window.height / pixel_scale).to_f
      @@window_current_width = @@width
      @@window_current_height = @@height
      @@renderer = SDL::Renderer.new(window, SDL::Renderer::Flags::ACCELERATED)
      if renderer = @@renderer
        renderer.draw_blend_mode = LibSDL::BlendMode::BLEND
      end
    end
  end

  def calculate_offset
    scl = 1
    if (win = @@window)
      cr_w = 0
      cr_h = 0
      ori_s = @@scale
      LibSDL.get_window_size(win, pointerof(cr_w), pointerof(cr_h))
      ratio = @@width/@@height
      current_ratio = cr_w.to_f/cr_h.to_f
      if (cr_w >= cr_h*ratio)
        # if wide
        @@draw_offset_y = 0
        scl = cr_h/@@height/ori_s
        @@draw_offset_x = (cr_w - cr_h*ratio)/2 / scl
      else
        # if tall
        @@draw_offset_x = 0
        scl = cr_w/@@width/ori_s
        @@draw_offset_y = ((cr_h - cr_w/ratio)/2) / scl
      end
    end
    if (r = @@renderer)
      r.scale = {scl, scl}
    end
  end

  def draw_resize_boxes
    if (lgr = Leafgem::Renderer.renderer)
      old_draw_color = lgr.draw_color
      lgr.draw_color = SDL::Color.new(0, 0, 0, 255)
      cr_w = 0
      cr_h = 0
      scale = lgr.scale[0]
      if (win = @@window)
        LibSDL.get_window_size(win, pointerof(cr_w), pointerof(cr_h))
        ratio = @@width/@@height

        w_width = (@@draw_offset_x).to_i
        lgr.fill_rect(-10, 0, w_width + 10, (cr_h/scale).to_i)
        lgr.fill_rect(((cr_w/scale) - w_width).to_i, 0, w_width + 10, (cr_h/scale).to_i)

        w_height = (@@draw_offset_y).to_i
        lgr.fill_rect(0, -10, (cr_w/scale).to_i, w_height + 10)
        lgr.fill_rect(0, (cr_h/scale).to_i - w_height, (cr_w/scale).to_i, w_height + 10)
      end
    end
  end

  def renderer
    @@renderer
  end

  def window
    @@window
  end

  def renderer
    if a = @@renderer
      a
    end
  end

  def camera
    @@camera
  end

  def width
    @@width
  end

  def height
    @@height
  end

  def scale
    @@scale
  end

  def fps
    @@fps
  end

  def set_fps(fps_to_set)
    @@fps = fps_to_set
  end

  def draw_offset_x
    @@draw_offset_x
  end

  def draw_offset_y
    @@draw_offset_y
  end

  extend self
end
