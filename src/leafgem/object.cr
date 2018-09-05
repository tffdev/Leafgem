class Leafgem::Object
  @anim_start_frame = 0
  @anim_end_frame = 0

  property hitbox = SDL::Rect.new(0, 0, 0, 0)

  property sprite_index = 0.0
  property spritesheet : Spritesheet?
  property sprite_speed = 0.0
  property is_animated = false

  property sprite_xscale = 1
  property sprite_yscale = 1

  property x = 0.0
  property y = 0.0
  property w = 1
  property h = 1

  def init
  end

  def update
  end

  def draw
    draw_self
  end

  def set_spritesheet(filename, @w : Int32 = w, @h : Int32 = h)
    if (@hitbox == SDL::Rect.new(0, 0, 0, 0))
      @hitbox = SDL::Rect.new(0, 0, w, h)
    end
    @spritesheet = Leafgem::Library.new_spritesheet(filename, w, h)
  end

  def set_hitbox(x, y, w, h)
    @hitbox = SDL::Rect.new(x, y, w, h)
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
        if !(@x > Leafgem::Renderer.width + camera_x ||
           @y > Leafgem::Renderer.height + camera_y ||
           @y + @h < camera_y ||
           @x + @w < camera_x)
          Leafgem::Renderer.draw(
            spr.sprite,
            spr.quads[@anim_start_frame + @sprite_index.to_i].x,
            spr.quads[@anim_start_frame + @sprite_index.to_i].y,
            @x,
            @y,
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

  def meeting?(x, y, foreign_object)
    # basic box collision
    # check each corner of self with every corner of every instance of the foreign object
    if (typeof(foreign_object) == Class || String)
      objs = Leafgem::Game.loop[foreign_object.to_s]
    else
      objs = foreign_object
    end
    if (objects_to_check = objs.as(Array(Leafgem::Object)))
      objects_to_check.each do |other|
        if (box_collision_check(self.hitbox, other.hitbox, x, y))
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
      [self.x + self.hitbox.x + xoffset, self.y + self.hitbox.y + yoffset],
      [self.x + self.hitbox.x + xoffset + self.hitbox.w, self.y + self.hitbox.y + yoffset],
      [self.x + self.hitbox.x + xoffset + self.hitbox.w, self.y + self.hitbox.y + yoffset + self.hitbox.h],
      [self.x + self.hitbox.x + xoffset, self.y + self.hitbox.y + yoffset + self.hitbox.h],
    ]
    # insert intermediate points between corners, for better checking
    (accuracy).times do |i|
      points_to_check.push([self.x + self.hitbox.x + xoffset + self.hitbox.w * 1/accuracy * i, self.y + self.hitbox.y + yoffset])
      points_to_check.push([self.x + self.hitbox.x + xoffset + self.hitbox.w * 1/accuracy * i, self.y + self.hitbox.y + yoffset + self.hitbox.h])
      points_to_check.push([self.x + self.hitbox.x + xoffset, self.y + self.hitbox.y + yoffset + self.hitbox.h * 1/accuracy * i])
      points_to_check.push([self.x + self.hitbox.x + xoffset + self.hitbox.w, self.y + self.hitbox.y + yoffset + self.hitbox.h * 1/accuracy * i])
    end

    points_to_check.each do |point|
      if (Leafgem::Map.get_tile_at(point[0], point[1]) == tile)
        return true
      end
    end
    return false
  end

  def meeting_tile_layer?(xoffset, yoffset, tilelayer, accuracy = 2)
    points_to_check = [
      [self.x + self.hitbox.x + xoffset, self.y + self.hitbox.y + yoffset],
      [self.x + self.hitbox.x + xoffset + self.hitbox.w, self.y + self.hitbox.y + yoffset],
      [self.x + self.hitbox.x + xoffset + self.hitbox.w, self.y + self.hitbox.y + yoffset + self.hitbox.h],
      [self.x + self.hitbox.x + xoffset, self.y + self.hitbox.y + yoffset + self.hitbox.h],
    ]
    # insert intermediate points between corners, for better checking
    (accuracy).times do |i|
      points_to_check.push([self.x + self.hitbox.x + xoffset + self.hitbox.w * 1/accuracy * i, self.y + self.hitbox.y + yoffset])
      points_to_check.push([self.x + self.hitbox.x + xoffset + self.hitbox.w * 1/accuracy * i, self.y + self.hitbox.y + yoffset + self.hitbox.h])
      points_to_check.push([self.x + self.hitbox.x + xoffset, self.y + self.hitbox.y + yoffset + self.hitbox.h * 1/accuracy * i])
      points_to_check.push([self.x + self.hitbox.x + xoffset + self.hitbox.w, self.y + self.hitbox.y + yoffset + self.hitbox.h * 1/accuracy * i])
    end
    points_to_check.each do |point|
      if (Leafgem::Map.get_tile_at(point[0], point[1]) != 0)
        return true
      end
    end
    return false
  end
end
