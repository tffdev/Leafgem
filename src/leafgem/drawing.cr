module Leafgem::Draw
  def sprite(image, sx, sy, x, y, w, h, ignore_camera = false)
    if (screen_surface = Leafgem::Renderer.surface)
      if (image)
        if (ignore_camera)
          image.blit(
            screen_surface,
            SDL::Rect.new(sx.to_i, sy.to_i, w, h),
            SDL::Rect.new(x.to_i, y.to_i, w.to_i, h.to_i)
          )
        else
          image.blit(
            screen_surface,
            SDL::Rect.new(sx.to_i, sy.to_i, w, h),
            SDL::Rect.new(
              x.to_i - (camera_x).to_i,
              y.to_i - (camera_y).to_i,
              w.to_i,
              h.to_i
            )
          )
        end
      end
    end
  end

  def fill_rect(rect)
    self.fill_rect(rect.x, rect.y, rect.w, rect.h)
  end

  def fill_rect(x, y, w, h, ignore_cam = false)
    cpos = Leafgem::Renderer.camera.pos
    rect = SDL::Rect.new(
      (x - ((ignore_cam) ? 0 : cpos.x.to_i)).to_i + ((w < 0) ? w : 0),
      (y - ((ignore_cam) ? 0 : cpos.y.to_i)).to_i + ((h < 0) ? h : 0),
      (w < 0) ? w.abs.to_i : w.to_i,
      (h < 0) ? h.abs.to_i : h.to_i
    )
    if (lgr = Leafgem::Renderer.renderer)
      if (screensurface = Leafgem::Renderer.surface)
        c = lgr.draw_color
        rect_surface = SDL::Surface.new(LibSDL.create_rgb_surface(0, 1, 1, 32, 0, 0, 0, 0))
        rect_surface.fill(c.r, c.g, c.b)
        rect_surface.blend_mode = LibSDL::BlendMode::BLEND
        rect_surface.alpha_mod = c.a
        rect_surface.blit_scaled(
          screensurface,
          SDL::Rect.new(0, 0, 1, 1),
          rect
        )
      end
    end
  end

  def draw_rect(rect)
    self.draw_rect(rect.x, rect.y, rect.w, rect.h)
  end

  def draw_rect(x, y, w, h, ignore_cam = false)
    fill_rect(x, y, w, 1, ignore_cam)
    fill_rect(x, y + h, w + 1, 1, ignore_cam)
    fill_rect(x, y + 1, 1, h - 1, ignore_cam)
    fill_rect(x + w, y, 1, h, ignore_cam)
  end

  # aaa, yummy slow circle drawing algorithms. pleasehelp
  def fill_circ(x, y, r)
    if r <= 0
      return
    end
    rad = 0
    prevy = nil
    prevx = nil
    while rad < Math::PI
      x1 = (Math.sin(rad)*r - 0.5).to_i
      y1 = (Math.cos(rad)*r - 0.5).to_i
      if (y1 != prevy || x1 != prevx)
        x2 = (Math.sin(-rad)*r - 0.5).to_i
        prevy = y1
        prevx = x1
        Leafgem::Draw.fill_rect(x + x1.to_i, y + y1.to_i, (x2 - x1 - 1).to_i, 1)
      end
      rad += (1.0 / r)
    end
  end

  def draw_circ(x, y, r)
  end

  extend self
end
