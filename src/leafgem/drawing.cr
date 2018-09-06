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
      ((x - Leafgem::Renderer.camera.pos.x)*Leafgem::Renderer.scale + Leafgem::Renderer.draw_offset_x).to_i,
      ((y - Leafgem::Renderer.camera.pos.y)*Leafgem::Renderer.scale + Leafgem::Renderer.draw_offset_y).to_i,
      (w*Leafgem::Renderer.scale).to_i,
      (h*Leafgem::Renderer.scale).to_i)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.fill_rect(rect.x, rect.y, rect.w, rect.h)
    end
  end

  # aaa, yummy slow circle drawing algorithms. pleasehelp
  def fill_circ(x, y, r)
    if (lgr = Leafgem::Renderer.renderer)
      lgr.scale = {Leafgem::Renderer.scale, Leafgem::Renderer.scale}
      rad = 0
      prevy = nil
      prevx = nil
      while rad < Math::PI
        x1 = (x + Math.sin(rad)*r - 0.5 - camera_x).to_i + Leafgem::Renderer.draw_offset_x
        y1 = ((y + Math.cos(rad)*r - 0.5 - camera_y)).to_i + Leafgem::Renderer.draw_offset_y
        if (y1 != prevy || x1 != prevx)
          x2 = (x + Math.sin(-rad)*r - 0.5 - camera_x).to_i + Leafgem::Renderer.draw_offset_x
          prevy = y1
          prevx = x1
          lgr.fill_rect(x1.to_i, y1.to_i, (x2 - x1 - 1).to_i, 1)
        end
        rad += (1.0 / r)
      end
      lgr.scale = {1, 1}
    end
  end

  def draw_circ(x, y, r)
    renderer.scale = {Leafgem::Renderer.scale, Leafgem::Renderer.scale}
    rad = 0
    prevx = nil
    prevy = nil
    while rad < Math::PI
      x1 = (x + Math.sin(rad)*r - 0.5 - camera_x).to_i + Leafgem::Renderer.draw_offset_x
      y1 = (y + Math.cos(rad)*r - 0.5 - camera_y).to_i + Leafgem::Renderer.draw_offset_y
      if (prevx != x1 || prevy != y1)
        x2 = (x + Math.sin(-rad)*r - 0.5 - camera_x).to_i + Leafgem::Renderer.draw_offset_x
        prevy = y1
        prevx = x1
        if (lgr = Leafgem::Renderer.renderer)
          lgr.draw_point(x1, y1)
          lgr.draw_point(x2, y1)
        end
      end
      rad += (1.0 / r)
    end
    renderer.scale = {1, 1}
  end

  extend self
end
