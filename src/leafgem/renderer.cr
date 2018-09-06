module Leafgem::Renderer
  @@fps = 60
  @@renderer : SDL::Renderer?
  @@window : SDL::Window?

  @@original_scale = 1
  @@scale = 1

  @@width = 0.0
  @@height = 0.0
  @@window_current_width = 0.0
  @@window_current_height = 0.0

  @@smoothcam = false
  @@smoothscale = 1.0

  @@camera = Leafgem::Camera.new

  @@draw_offset_x = 0.0
  @@draw_offset_y = 0.0

  def create(window_title : String, window_width : Int32, window_height : Int32, pixel_scale : Float32, smooth_cam : Bool)
    # Create window
    @@window = SDL::Window.new(window_title, window_width, window_height, LibSDL::WindowPosition::UNDEFINED, LibSDL::WindowPosition::UNDEFINED, LibSDL::WindowFlags::RESIZABLE)
    # used as reference for window resizing
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
    # Set renderer pixel scale
    if (smooth_cam == true)
      @@smoothscale = pixel_scale
    elsif renderer = @@renderer
      @@original_scale = pixel_scale
      renderer.scale = {pixel_scale, pixel_scale}
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
        @@draw_offset_x = (cr_w - cr_h*ratio)/2 / scl / @@original_scale
      else
        # if tall
        @@draw_offset_x = 0
        scl = cr_w/@@width/ori_s
        @@draw_offset_y = ((cr_h - cr_w/ratio)/2) / scl / @@original_scale
      end
    end
    if (r = @@renderer)
      r.scale = {scl*@@original_scale, scl*@@original_scale}
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

  def draw(texture, sx, sy, x, y, w, h, ignore_camera = false)
    if (lgr = Leafgem::Renderer.renderer)
      if (ignore_camera)
        lgr.copy(
          texture,
          SDL::Rect.new(sx.to_i, sy.to_i, w, h),
          SDL::Rect.new((@@draw_offset_x + x*@@smoothscale).to_i, (@@draw_offset_y + y*@@smoothscale).to_i, (w*@@smoothscale).to_i, (h*@@smoothscale).to_i)
        )
      else
        lgr.copy(
          texture,
          SDL::Rect.new(sx.to_i, sy.to_i, w, h),
          SDL::Rect.new((@@draw_offset_x + x*@@smoothscale).to_i - (camera_x*@@smoothscale).to_i, (@@draw_offset_y + y*@@smoothscale).to_i - (camera_y*@@smoothscale).to_i, (w*@@smoothscale).to_i, (h*@@smoothscale).to_i)
        )
      end
    end
  end

  def fill_rect(x, y, w, h)
    rect = SDL::Rect.new((@@draw_offset_x + x*@@smoothscale).to_i - (camera_x*@@smoothscale).to_i, (@@draw_offset_y + y*@@smoothscale).to_i - (camera_y*@@smoothscale).to_i, (w*@@smoothscale).to_i, (h*@@smoothscale).to_i)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.fill_rect(rect.x, rect.y, rect.w, rect.h)
    end
  end

  # aaa, yummy slow circle drawing algorithms. pleasehelp
  def fill_circ(x, y, r)
    renderer.scale = {@@scale, @@scale} if (@@smoothcam)
    rad = 0
    prevy = nil
    prevx = nil
    while rad < Math.PI
      x1 = (x + Math.sin(rad)*r - 0.5 - camera_x).to_i + @@draw_offset_x
      y1 = ((y + Math.cos(rad)*r - 0.5 - camera_y)).to_i + @@draw_offset_y
      if (y1 != prevy || x1 != prevx)
        x2 = (x + Math.sin(-rad)*r - 0.5 - camera_x).to_i + @@draw_offset_x
        prevy = y1
        prevx = x1
        if (lgr = Leafgem::Renderer.renderer)
          lgr.fill_rect(x1, y1, x2 - x1 - 1, 1)
        end
      end
      rad += (1.0 / r)
    end
    renderer.scale = {1, 1} if (@@smoothcam)
  end

  def draw_circ(x, y, r)
    renderer.scale = {@@scale, @@scale} if (@@smoothcam)
    rad = 0
    prevx = nil
    prevy = nil
    while rad < Math.PI
      x1 = (x + Math.sin(rad)*r - 0.5 - camera_x).to_i + @@draw_offset_x
      y1 = (y + Math.cos(rad)*r - 0.5 - camera_y).to_i + @@draw_offset_y
      if (prevx != x1 || prevy != y1)
        x2 = (x + Math.sin(-rad)*r - 0.5 - camera_x).to_i + @@draw_offset_x
        prevy = y1
        prevx = x1
        if (lgr = Leafgem::Renderer.renderer)
          lgr.draw_point(x1, y1)
          lgr.draw_point(x2, y1)
        end
      end
      rad += (1.0 / r)
    end
    renderer.scale = {1, 1} if (@@smoothcam)
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
    if r = @@renderer
      r.scale[0]
    else
      0
    end
  end

  def fps
    @@fps
  end

  def set_fps(fps_to_set)
    @@fps = fps_to_set
  end

  def set_smooth_camera(bool)
    @@smoothcam = bool
  end

  def draw_offset_x
    @@draw_offset_x
  end

  def draw_offset_y
    @@draw_offset_y
  end

  extend self
end
