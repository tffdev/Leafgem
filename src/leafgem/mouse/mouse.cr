module Leafgem::Mouse::Mouse
  @@scroll = Scroll.new
  @@buttons = {} of UInt8 => Click
  @@position = NewVec2(Int32).new(0, 0)
  @@scrolling = false

  # Buttons clicked
  def buttons
    @@buttons
  end

  # The position of the mouse on screen
  def position
    @@position
  end

  # TODO: Finish scroll events
  def scrolling?
    @@scroll.active?
  end

  def update
    @@buttons.each do |i, button|
      button.update
    end

    @@scroll.update
  end

  # Update the mouse
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

  # Enable or Disable the cursor
  def cursor=(bool : Bool)
    if bool
      LibSDL.show_cursor(1)
    else
      LibSDL.show_cursor(0)
    end
  end

  # Resets the cursor
  def cursor=(name : Nil)
    self.cursor = LibSDL.create_system_cursor(LibSDL::SystemCursor::ARROW)
  end

  # BUG: `LibSDL::SystemCursor::WAIT` and `LibSDL::SystemCursor::WAITARROW` seem to be semi-broken
  # NOTE: When the cursor is a custom one the mouse input delay seems to be increased
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

  # Set the cursor with a pointer
  def cursor=(cursor : Pointer(LibSDL::Cursor))
    LibSDL.set_cursor(cursor)
  end

  # Update the mouse
  def update(event : SDL::Event::MouseMotion)
    @@position = NewVec2.from event.x, event.y
  end

  # TODO: Finish this
  def update(event : SDL::Event::MouseWheel)
    @@scroll.update event
  end

  # Gets the primary button event if it exists
  def primary
    @@buttons[1_u8]?
  end

  # Gets the secondary button click event if it exists
  def secondary
    @@buttons[3_u8]?
  end

  # Gets the middle button click event if it exists
  def middle
    @@buttons[2_u8]?
  end

  # Gets the button click event by the id if it exists
  def button(id : UInt8)
    @@buttons[id]?
  end

  def scroll
    @@scroll
  end
end
