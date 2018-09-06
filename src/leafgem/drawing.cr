module Leafgem::Draw
  def sprite(texture, sx, sy, x, y, w, h, ignore_camera = false)
    if (lgr = Leafgem::Renderer.renderer)
      if (ignore_camera)
        lgr.copy(
          texture,
          SDL::Rect.new(sx.to_i, sy.to_i, w, h),
          SDL::Rect.new((Leafgem::Renderer.draw_offset_x + x*Leafgem::Renderer.scale).to_i, (Leafgem::Renderer.draw_offset_y + y*Leafgem::Renderer.scale).to_i, (w*Leafgem::Renderer.scale).to_i, (h*Leafgem::Renderer.scale).to_i)
        )
      else
        lgr.copy(
          texture,
          SDL::Rect.new(sx.to_i, sy.to_i, w, h),
          SDL::Rect.new((Leafgem::Renderer.draw_offset_x + x*Leafgem::Renderer.scale).to_i - (camera_x*Leafgem::Renderer.scale).to_i, (Leafgem::Renderer.draw_offset_y + y*Leafgem::Renderer.scale).to_i - (camera_y*Leafgem::Renderer.scale).to_i, (w*Leafgem::Renderer.scale).to_i, (h*Leafgem::Renderer.scale).to_i)
        )
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
    renderer.scale = {Leafgem::Renderer.scale, Leafgem::Renderer.scale}
    rad = 0
    prevy = nil
    prevx = nil
    while rad < Math.PI
      x1 = (x + Math.sin(rad)*r - 0.5 - camera_x).to_i + Leafgem::Renderer.draw_offset_x
      y1 = ((y + Math.cos(rad)*r - 0.5 - camera_y)).to_i + Leafgem::Renderer.draw_offset_y
      if (y1 != prevy || x1 != prevx)
        x2 = (x + Math.sin(-rad)*r - 0.5 - camera_x).to_i + Leafgem::Renderer.draw_offset_x
        prevy = y1
        prevx = x1
        if (lgr = Leafgem::Renderer.renderer)
          lgr.fill_rect(x1, y1, x2 - x1 - 1, 1)
        end
      end
      rad += (1.0 / r)
    end
    renderer.scale = {1, 1}
  end

  def draw_circ(x, y, r)
    renderer.scale = {Leafgem::Renderer.scale, Leafgem::Renderer.scale}
    rad = 0
    prevx = nil
    prevy = nil
    while rad < Math.PI
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
