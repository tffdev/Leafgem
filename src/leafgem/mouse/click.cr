class Leafgem::Mouse::Click
  property position : Vec2
  property event : SDL::Event::MouseButton
  property held : Bool

  def initialize(@event, @pressed = true)
    @position = Vec2.new @event.x, @event.y
    @held = !@pressed
    # @when_pressed = event.timestamp
  end

  def held?
    @held
  end

  def pressed?
    @pressed
  end

  def update
    @pressed = false
    @held = !@pressed
  end

  def update(@event, @pressed = false)
    @position = Vec2.new @event.x, @event.y
    @held = !@pressed
  end
end
