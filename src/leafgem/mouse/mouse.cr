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

  # Note
  # WAIT, WAITARROW
  # Seems to be semi-broken

  # Note
  # When the cursor is a custom one
  # The mouse input delay seems to be increased

  def cursor=(bool : Bool)
    if bool
      LibSDL.show_cursor(1)
    else
      LibSDL.show_cursor(0)
    end
  end

  def cursor=(name : Nil)
    self.cursor = LibSDL.create_system_cursor(LibSDL::SystemCursor::ARROW)
  end

  def cursor=(name : String)
    case name
    when "reset"
      cursor_name = LibSDL::SystemCursor::ARROW
    when .starts_with? "point"
      cursor_name = LibSDL::SystemCursor::HAND
    when "edit"
      cursor_name = LibSDL::SystemCursor::IBEAM
    when .starts_with?("load")
      cursor_name = LibSDL::SystemCursor::WAIT
    when "grab"
      cursor_name = LibSDL::SystemCursor::SIZENWSE
    when "horizontal"
      cursor_name = LibSDL::SystemCursor::SIZEWE
    when "vertical"
      cursor_name = LibSDL::SystemCursor::SIZENS
    when .starts_with?("cancel"), .starts_with?("block")
      cursor_name = LibSDL::SystemCursor::NO
    else
      cursor_name = LibSDL::SystemCursor.parse(name)
    end

    self.cursor = LibSDL.create_system_cursor(cursor_name)
  end

  def cursor=(cursor : Pointer(LibSDL::Cursor))
    LibSDL.set_cursor(cursor)
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
