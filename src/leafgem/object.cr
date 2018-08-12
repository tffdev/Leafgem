class Leafgem::Object
  @image_index : Spritesheet?
  @sprite_index = 0.0
  @image_speed = 0.0
  @anim_start_frame = 0
  @anim_end_frame = 0

  property x = 0.0
  property y = 0.0
  property w = 0
  property h = 0

  property image_index
  property image_speed

  def init
  end

  def update
  end

  def draw
    draw_self
  end

  def draw_self
    if spr = @image_index
      @sprite_index += @image_speed
      if (@sprite_index > @anim_end_frame - @anim_start_frame + 1)
        @sprite_index = 0
      end
      Leafgem::Renderer.renderer.copy(
        spr.sprite,
        spr.quads[@anim_start_frame + @sprite_index.to_i],
        SDL::Rect.new((@x - camera_x).to_i, (@y - camera_y).to_i, spr.quads[0].w, spr.quads[0].h)
      )
    end
  end

  def set_animation(cols, param_row = 0, image_speed = Nil)
    if imgspd = image_speed
      @image_speed = imgspd
    end
    if param_row != 0
      if image_index = @image_index
        offset_y = (image_index.sprite.width / image_index.quads[0].w).to_i * param_row
        @anim_start_frame = offset_y + cols[0]
        @anim_end_frame = offset_y + cols[cols.size - 1]
      end
    else
      @anim_start_frame = cols[0]
      @anim_end_frame = cols[cols.size - 1]
    end
  end
end
