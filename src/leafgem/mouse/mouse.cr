module Leafgem::Mouse::Mouse
  @@buttons = {} of UInt8 => Click
  @@position = nil
  @@scrolling = false

  def buttons
    @@buttons
  end

  def position
    @@position
  end

  def scrolling?
    @@scrolling
  end

  # When the mouse clicks
  def update(event : SDL::Event::MouseButton)
    if event.type.to_s.downcase.ends_with? "down"
      first_pressed = !@@buttons[event.button]?

      if first_pressed
        click = Click.new event, first_pressed
        @@buttons[event.button] = click
      else
        @@buttons[event.button].update event
      end
    end

    if event.type.to_s.downcase.ends_with? "up"
      @@buttons.delete event.button
    end
  end

  # When the mouse moves
  def update(event : SDL::Event::MouseMotion)
    @@position = Vec2.new event.x, event.y
  end

  def update(event : SDL::Event::MouseWheel); end

  def primary
    @@buttons[1_u8]?
  end

  def secondary
    @@buttons[3_u8]?
  end

  def middle
    @@buttons[2_u8]?
  end

  def button(id : UInt8)
    @@buttons[id]?
  end

  def scrolling?
    @@scrolling
  end
end
