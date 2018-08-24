class Leafgem::Object
  @anim_start_frame = 0
  @anim_end_frame = 0

  property sprite_index = 0.0
  property image_index : Spritesheet?
  property image_speed = 0.0
  property is_animated = false

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

  def update_spritesheet
    if sprsheet = @image_index
      @w = sprsheet.quads[0].w
      @h = sprsheet.quads[0].h
    end
  end

  def draw_self
    if spr = @image_index
      @sprite_index += @image_speed
      if (@sprite_index > @anim_end_frame - @anim_start_frame + 1)
        @sprite_index = 0
      end

      if (window = Leafgem::Renderer.window)
        # If the object is on screen
        # if (
        #      @x < window.width/Leafgem::Renderer.scale + camera_x &&
        #      @y < window.height/Leafgem::Renderer.scale + camera_y
        #    )

        Leafgem::Renderer.draw(
          spr.sprite,
          spr.quads[@anim_start_frame + @sprite_index.to_i].x,
          spr.quads[@anim_start_frame + @sprite_index.to_i].y,
          @x,
          @y,
          spr.quads[0].w,
          spr.quads[0].h
        )
        # end
      end
    end
  end

  def set_animation(cols, param_row = 0, image_speed = Nil)
    @is_animated = true
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

  def place_meeting(x, y, foreign_object)
    # basic box collision
    # check each corner of self with every corner of every instance of the foreign object
    objects_to_check = Leafgem::Game.loop[foreign_object.to_s]
    objects_to_check.each do |other|
      if self.x + x >= other.x && self.x + x < other.x + other.w && self.y + y >= other.y && self.y + y < other.y + other.h ||
         (self.x + x + self.w) >= other.x && (self.x + x + self.w) < other.x + other.w && self.y + y >= other.y && self.y + y < other.y + other.h ||
         (self.x + x + self.w) >= other.x && (self.x + x + self.w) < other.x + other.w && (self.y + y + self.h) >= other.y && (self.y + y + self.h) < other.y + other.h ||
         self.x + x >= other.x && self.x + x < other.x + other.w && (self.y + y + self.h) >= other.y && (self.y + y + self.h) < other.y + other.h
        return true
      end
    end
    return false
  end
end
