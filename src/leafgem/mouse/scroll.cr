class Leafgem::Mouse::Scroll
  property active : Bool
  property direction : Vec2(Int32)
  property event : SDL::Event::MouseWheel?

  def initialize
    @active = false
    @direction = Vec2.from 0, 0
    @event = nil
  end

  def update(event : SDL::Event::MouseWheel)
    @active = true
    @direction = Vec2.from event.x, event.y
  end

  def update
    @active = false
    @direction = Vec2.from 0, 0
  end

  def up?
    @direction.y > 0
  end

  def down?
    @direction.y < 0
  end

  def left?
    @direction.x < 0
  end

  def right?
    @direction.x > 0
  end

  def active?
    @active
  end
end
