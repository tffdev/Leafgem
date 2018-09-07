module Leafgem::Draw
  def sprite(image, sx, sy, x, y, w, h, ignore_camera = false)
    if (screen_surface = Leafgem::Renderer.surface)
      if (image)
        if (ignore_camera)
          image.blit(
            screen_surface,
            SDL::Rect.new(sx.to_i, sy.to_i, w, h),
            SDL::Rect.new(
              (Leafgem::Renderer.draw_offset_x + x).to_i,
              (Leafgem::Renderer.draw_offset_y + y).to_i,
              (w*Leafgem::Renderer.scale).to_i,
              (h*Leafgem::Renderer.scale).to_i)
          )
        else
          image.blit(
            screen_surface,
            SDL::Rect.new(sx.to_i, sy.to_i, w, h),
            SDL::Rect.new(
              (Leafgem::Renderer.draw_offset_x + x).to_i - (camera_x).to_i,
              (Leafgem::Renderer.draw_offset_y + y).to_i - (camera_y).to_i,
              (w).to_i,
              (h).to_i)
          )
        end
      end
    end
  end

  def fill_rect(x, y, w, h)
    rect = SDL::Rect.new(
      (x - Leafgem::Renderer.camera.pos.x).to_i + ((w < 0) ? w : 0),
      (y - Leafgem::Renderer.camera.pos.y).to_i + ((h < 0) ? h : 0),
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

  # aaa, yummy slow circle drawing algorithms. pleasehelp
  def fill_circ(x, y, r)
    rad = 0
    prevy = nil
    prevx = nil
    while rad < Math::PI
      x1 = (x + Math.sin(rad)*r - 0.5).to_i
      y1 = ((y + Math.cos(rad)*r - 0.5)).to_i
      if (y1 != prevy || x1 != prevx)
        x2 = (x + Math.sin(-rad)*r - 0.5).to_i
        prevy = y1
        prevx = x1
        Leafgem::Draw.fill_rect(x1.to_i, y1.to_i, (x2 - x1 - 1).to_i, 1)
      end
      rad += (1.0 / r)
    end
  end

  def draw_circ(x, y, r)
  end

  extend self
end
