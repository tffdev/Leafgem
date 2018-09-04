class Leafgem::Mouse::WheelManager
  def self.update(event)
    pp event
  end

  # I'm a little unsure if this the correct way.
  def up?
    event.y > 0
  end

  def down?
    event.y < 0
  end

  def left?
    event.x > 0
  end

  def right?
    event.x < 0
  end
end
