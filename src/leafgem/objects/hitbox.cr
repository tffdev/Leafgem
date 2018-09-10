class Leafgem::Objects::Hitbox
  property pos : Vec2(Float64)
  property size : Vec2(Float64)

  def initialize(@pos : Vec2, @size : Vec2)
  end

  def set(x, y, w, h)
    @pos = Vec2[x, y].to_f
    @size = Vec2[w, h].to_f
  end

  def get
    {@pos, @size}
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
    x >= @pos.x && x <= @pos.y + @w && y >= @pos.y && y <= @pos.y + @h
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
      [self.pos.x + @pos.x + xoffset, self.pos.x + @pos.y + yoffset],
      [self.pos.x + @pos.x + xoffset + @size.x, self.pos.x + @pos.y + yoffset],
      [self.pos.x + @pos.x + xoffset + @size.x, self.pos.x + @pos.y + yoffset + @size.y],
      [self.pos.x + @pos.x + xoffset, self.pos.x + @pos.y + yoffset + @size.y],
    ]
    # insert intermediate points between corners, for better checking
    (accuracy).times do |i|
      points_to_check.push([self.pos.x + @pos.x + xoffset + @size.x * 1/accuracy * i, self.pos.x + @pos.y + yoffset])
      points_to_check.push([self.pos.x + @pos.x + xoffset + @size.x * 1/accuracy * i, self.pos.x + @pos.y + yoffset + @size.y])
      points_to_check.push([self.pos.x + @pos.x + xoffset, self.pos.x + @pos.y + yoffset + @size.y * 1/accuracy * i])
      points_to_check.push([self.pos.x + @pos.x + xoffset + @size.x, self.pos.x + @pos.y + yoffset + @size.y * 1/accuracy * i])
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
      [self.pos.x + @pos.x + xoffset, self.pos.x + @pos.y + yoffset],
      [self.pos.x + @pos.x + xoffset + @size.x, self.pos.x + @pos.y + yoffset],
      [self.pos.x + @pos.x + xoffset + @size.x, self.pos.x + @pos.y + yoffset + @size.y],
      [self.pos.x + @pos.x + xoffset, self.pos.x + @pos.y + yoffset + @size.y],
    ]
    # insert intermediate points between corners, for better checking
    (accuracy).times do |i|
      points_to_check.push([self.pos.x + @pos.x + xoffset + @size.x * 1/accuracy * i, self.pos.x + @pos.y + yoffset])
      points_to_check.push([self.pos.x + @pos.x + xoffset + @size.x * 1/accuracy * i, self.pos.x + @pos.y + yoffset + @size.y])
      points_to_check.push([self.pos.x + @pos.x + xoffset, self.pos.x + @pos.y + yoffset + @size.y * 1/accuracy * i])
      points_to_check.push([self.pos.x + @pos.x + xoffset + @size.x, self.pos.x + @pos.y + yoffset + @size.y * 1/accuracy * i])
    end
    points_to_check.each do |point|
      if (Leafgem::Map.get_tile_at(point[0], point[1], tilelayer) != 0)
        return true
      end
    end
    return false
  end
end
