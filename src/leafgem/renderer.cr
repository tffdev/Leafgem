module Leafgem::Renderer
  @@fps = 60
  @@renderer : SDL::Renderer?

  @@scale = 1

  @@size = Vec2.new(0, 0)
  @@window : Leafgem::Window?

  @@camera = Leafgem::Camera.new

  @@offset = Vec2.new(0, 0)

  @@screen_surface : SDL::Surface?
  @@screen_surface_pointer : Pointer(LibSDL::Surface)?

  def create(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32)
    # Create window
    @@window = Leafgem::Window.new(window_title, window_width, window_height, true)
    @@scale = pixel_scale
    @@size = Vec2.new(window_width/pixel_scale, window_height/pixel_scale)
    # Create renderer
    @@screen_surface_pointer = LibSDL.create_rgb_surface(0, @@size.x, @@size.y, 32, 0, 0, 0, 0)
    if (ssp = @@screen_surface_pointer)
      @@screen_surface = SDL::Surface.new(ssp)
    end
    puts "CREATED SCREEN SURFACE:"
    pp @@screen_surface
    if (window = @@window)
      @@renderer = SDL::Renderer.new(window.window, SDL::Renderer::Flags::ACCELERATED)
      if renderer = @@renderer
        renderer.draw_blend_mode = LibSDL::BlendMode::BLEND
      end
    end
  end

  def surface
    @@screen_surface
  end

  def present
    if (lg_r = @@renderer)
      if (s_surface = @@screen_surface)
        # copy prerendered screen surface to renderer surface
        texture = SDL::Texture.from(s_surface, lg_r)
        lg_r.copy(
          texture,
          SDL::Rect.new(0, 0, texture.width, texture.height),
          SDL::Rect.new(0, 0, (texture.width*@@scale).to_i, (texture.height*@@scale).to_i)
        )
        lg_r.present
      end
    end
  end

  def calculate_offset
    # if (window = @@window)
    #   w_csize = window.current_size
    #   ratio = @@size.x.to_f / @@size.y.to_f
    #   current_ratio = w_csize.x.to_f / w_csize.y.to_f
    #   debug "ratio #{ratio}"
    #   debug "current_ratio #{current_ratio}"
    #   if (w_csize.x >= w_csize.y*ratio)
    #     # if wide
    #     @@offset.y = 0
    #     scl = w_csize.y/@@size.x/@@scale
    #     debug "scl #{scl}"
    #     @@offset.x = (((w_csize.x - w_csize.y/ratio)/2) / scl).to_i
    #   else
    #     # if tall
    #     @@offset.x = 0
    #     scl = w_csize.x/@@size.y/@@scale
    #     @@offset.y = (((w_csize.y - w_csize.x/ratio)/2) / scl).to_i
    #   end
    # end
  end

  def draw_resize_boxes
  end

  def renderer
    @@renderer
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

  def draw_offset_x
    @@offset.x
  end

  def draw_offset_y
    @@offset.y
  end

  extend self
end
