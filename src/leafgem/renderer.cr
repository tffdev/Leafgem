module Leafgem::Renderer
  @@fps = 60
  @@renderer : SDL::Renderer?

  @@scale = 1

  @@size = Vec2(Int32).new 0, 0
  @@window : Leafgem::Window?

  @@camera = Leafgem::Camera.new

  @@offset = Vec2(Int32).new 0, 0

  @@screen_surface : SDL::Surface?
  @@screen_surface_pointer : Pointer(LibSDL::Surface)?

  def create(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32)
    # Create window
    @@window = Leafgem::Window.new(window_title, window_width, window_height, true)
    @@scale = pixel_scale
    @@size = Vec2.from(window_width/pixel_scale, window_height/pixel_scale).to_i
    # Create renderer
    @@screen_surface_pointer = LibSDL.create_rgb_surface(0, @@size.x, @@size.y, 32, 0, 0, 0, 0)
    if (ssp = @@screen_surface_pointer)
      @@screen_surface = SDL::Surface.new(ssp)
    end
    if (window = @@window)
      @@renderer = SDL::Renderer.new(window.window, SDL::Renderer::Flags::ACCELERATED)
      if renderer = @@renderer
        renderer.draw_blend_mode = LibSDL::BlendMode::BLEND
      end
    end
  end

  def clear_screen(r, g, b)
    if (lg_r = Leafgem::Renderer.renderer)
      # set background to black
      old_color = lg_r.draw_color
      lg_r.draw_color = SDL::Color[r, g, b, 255]
      lg_r.clear
      lg_r.draw_color = old_color
    end
    if (surf = Leafgem::Renderer.surface)
      surf.fill(255, 255, 255)
    end
  end

  def surface
    @@screen_surface
  end

  def draw_buffer
    if (lg_r = @@renderer)
      if (s_surface = @@screen_surface)
        # copy prerendered screen surface to renderer surface
        texture = SDL::Texture.from(s_surface, lg_r)
        output_rect = self.calculate_onscreen_rect
        lg_r.copy(
          texture,
          SDL::Rect.new(0, 0, texture.width, texture.height),
          output_rect
        )
      end
    end
  end

  def calculate_onscreen_rect
    if (window = @@window)
      c_size = window.current_size
      @@scale = Math.min(c_size.x.to_f / size.x, c_size.y.to_f / size.y).to_f32
      ratio = size.x.to_f/size.y
      @@offset.x = Math.max(((c_size.x - c_size.y*ratio)/2), 0).to_i
      @@offset.y = Math.max(((c_size.y - c_size.x/ratio)/2), 0).to_i
      SDL::Rect.new(@@offset.x, @@offset.y, (size.x*@@scale).to_i, (size.y*@@scale).to_i)
    end
  end

  def present
    if (lg_r = @@renderer)
      lg_r.present
    end
  end

  def renderer
    if a = @@renderer
      a
    end
  end

  def window
    @@window
  end

  def camera
    @@camera
  end

  def size
    @@size
  end

  def scale
    @@scale
  end

  def current_scale
    if a = @@renderer
      a.scale[0]
    end
  end

  def fps
    @@fps
  end

  def set_fps(fps_to_set)
    @@fps = fps_to_set
  end

  def offset
    @@offset
  end

  extend self
end
