class Leafgem::Object
  @anim_start_frame = 0
  @anim_end_frame = 0

  property sprite_index = 0.0
  property spritesheet : Spritesheet?
  property image_speed = 0.0
  property is_animated = false

  property x = 0.0
  property y = 0.0
  property w = 0
  property h = 0

  def init
  end

  def update
  end

  def draw
    draw_self
  end

  def set_spritesheet(filename, w, h)
    @w = w
    @h = h
    @spritesheet = new_spritesheet(filename, w, h)
  end

  def update_spritesheet
    if sprsheet = @spritesheet
      @w = sprsheet.quads[0].w
      @h = sprsheet.quads[0].h
    end
  end

  def draw_self
    if spr = @spritesheet
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

  def place_meeting(x, y, foreign_object)
    # basic box collision
    # check each corner of self with every corner of every instance of the foreign object
    if (typeof(foreign_object) == Class || String)
      objs = Leafgem::Game.loop[foreign_object.to_s]
    else
      objs = foreign_object
    end
    if (objects_to_check = objs.as(Array(Leafgem::Object)))
      objects_to_check.each do |other|
        if (box_collision_check(self, other, x, y))
          return true
        end
      end
    end
    return false
  end

  def point_in?(x, y)
    x >= @x && x <= @x + @w && y >= @y && y <= @y + @h
  end

  def box_collision_check(this, other, x, y)
    if this.x + x >= other.x && this.x + x < other.x + other.w && this.y + y >= other.y && this.y + y < other.y + other.h ||
       (this.x + x + this.w) >= other.x && (this.x + x + this.w) < other.x + other.w && this.y + y >= other.y && this.y + y < other.y + other.h ||
       (this.x + x + this.w) >= other.x && (this.x + x + this.w) < other.x + other.w && (this.y + y + this.h) >= other.y && (this.y + y + this.h) < other.y + other.h ||
       this.x + x >= other.x && this.x + x < other.x + other.w && (this.y + y + this.h) >= other.y && (this.y + y + this.h) < other.y + other.h
      return true
    else
      return false
    end
  end

  def meeting_tile?(xoffset, yoffset, tile, accuracy = 2)
    # insert corners
    points_to_check = [
      [self.x + xoffset, self.y + yoffset],
      [self.x + xoffset + self.w, self.y + yoffset],
      [self.x + xoffset + self.w, self.y + yoffset + self.h],
      [self.x + xoffset, self.y + yoffset + self.h],
    ]
    # insert intermediate points between corners, for better checking
    (accuracy).times do |i|
      points_to_check.push([self.x + xoffset + self.w * 1/accuracy * i, self.y + yoffset])
      points_to_check.push([self.x + xoffset + self.w * 1/accuracy * i, self.y + yoffset + self.h])
      points_to_check.push([self.x + xoffset, self.y + yoffset + self.h * 1/accuracy * i])
      points_to_check.push([self.x + xoffset + self.w, self.y + yoffset + self.h * 1/accuracy * i])
    end

    points_to_check.each do |point|
      if (Leafgem::Map.get_tile_at(point[0], point[1]) == tile)
        return true
      end
    end

    return false
  end
end
