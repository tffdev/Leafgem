require "./object"

class Leafgem::DrawnObject < Leafgem::Object
  @anim_start_frame = 0
  @anim_end_frame = 0

  property sprite_index = 0.0
  property spritesheet : Spritesheet?
  property sprite_speed = 0.0
  property is_animated = false
  property sprite_xscale = 1
  property sprite_yscale = 1

  def draw
    draw_self
  end

  def set_spritesheet(filename, @w : Int32 = w, @h : Int32 = h)
    if (@hitbox.get == {0, 0, 0, 0})
      @hitbox.set(0, 0, w, h)
    end
    @spritesheet = Leafgem::Library.new_spritesheet(filename, w, h)
  end

  def update_spritesheet
    if sprsheet = @spritesheet
      @w = sprsheet.quads[0].w
      @h = sprsheet.quads[0].h
    end
  end

  def draw_self
    if spr = @spritesheet
      @sprite_index += @sprite_speed
      if (@sprite_index > @anim_end_frame - @anim_start_frame + 1)
        @sprite_index = 0
      end

      if (window = Leafgem::Renderer.window)
        # If the object is on screen
        if !(@position.x > Leafgem::Renderer.size.x + camera_x ||
           @position.y > Leafgem::Renderer.size.y + camera_y ||
           @position.y + @size.y < camera_y ||
           @position.x + @size.x < camera_x)
          Leafgem::Draw.sprite(
            spr.sprite,
            spr.quads[@anim_start_frame + @sprite_index.to_i].x,
            spr.quads[@anim_start_frame + @sprite_index.to_i].y,
            @position.x,
            @position.y,
            spr.quads[0].w,
            spr.quads[0].h
          )
        end
      end
    end
  end

  def set_animation(anim)
    self.set_animation(anim[0].as(Array(Int32)), anim[1].as(Int32), anim[2].as(Float64))
  end

  def set_animation(cols : Array(Int32), param_row : Int32, sprite_speed : Float64 = Nil)
    @is_animated = true
    if imgspd = sprite_speed
      @sprite_speed = imgspd
    end
    if param_row != 0
      if spritesheet = @spritesheet
        offset_y = (spritesheet.sprite.width / spritesheet.quads[0].w).to_i * param_row
        @anim_start_frame = offset_y + cols[0]
        @anim_end_frame = offset_y + cols[cols.size - 1]
      end
    else
      @anim_start_frame = cols[0]
      @anim_end_frame = cols[cols.size - 1]
    end
  end
end
