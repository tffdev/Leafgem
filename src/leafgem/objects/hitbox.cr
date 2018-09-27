# A hitbox
#
# Hitboxes are used for collision
#
# By default any `Leafgem::Object`
# will have a hitbox attatched to it
class Leafgem::Hitbox
  property pos : Vec2(Int32)
  property size : Vec2(Int32)

  def initialize(@pos : Vec2, @size : Vec2)
  end

  # Sets the hitboxx position and size
  def set(x, y, w, h)
    @pos = Vec2.from x, y
    @size = Vec2.from w, h
  end

  # Get the hitbox position and size as a tuple
  def get
    {@pos.x, @pos.y, @size.x, @size.y}
  end

  # is the hitbox meeting another object?
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

  # Is the position in the hitbox?
  def point_in?(x, y)
    x >= @pos.x && x <= @pos.y + @size.x && y >= @pos.y && y <= @pos.y + @size.y
  end

  # NOTE: This is weird
  #
  # Is their another hitbox in this one?
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

  # Is the hitbox meeting a tile?
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

  # Is the hitbox meeting a tile based on the layer
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
      if (Leafgem::Map.get_tile_at(point[0], point[1], tilelayer) != 0)
        return true
      end
    end
    return false
  end

  # Is the mouse in the hitbox?
  def mouse_in?
    point_in? Library::Mouse.pos.x, Library::Mouse.pos.y
  end

  # Is the hitbox pressed?
  def pressed?
    if b = Library::Mouse.primary
      mouse_in? && b.pressed?
    else
      false
    end
  end

  # Was the hitbox held?
  def held?
    if b = Library::Mouse.primary
      mouse_in? && b.held?
    else
      false
    end
  end
end
