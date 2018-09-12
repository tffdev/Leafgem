require "../objects/hitbox"

class Leafgem::Hitbox
  # TODO: Change to a macro
  # Is the mouse in the hitbox?
  def mouse_in?
    point_in? Library::Mouse.pos.x, Library::Mouse.pos.y
  end

  # Did the hitbox get pressed?
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
