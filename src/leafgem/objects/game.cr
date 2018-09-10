require "./drawn"

class Leafgem::Objects::Game < Leafgem::Objects::Drawn
  def set_hitbox(x, y, w, h)
    self.hitbox.set(x, y, w, h)
  end
end
