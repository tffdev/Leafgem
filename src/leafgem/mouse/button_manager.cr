class Leafgem::Mouse::ButtonManager
  @@buttons_pressed = [] of UInt8

  def self.update(event)
    pp event

    if event.type.to_s.downcase.ends_with? "down"
      @@buttons_pressed.push(event.button)
    end

    if event.type.to_s.downcase.ends_with? "up"
      @@buttons_pressed.delete event.button
    end
  end

  def buttons_pressed
    @@buttons_pressed
  end

  def primary?
    @@buttons_pressed.any? { |i| i === 1_u8 }
  end

  def secondary?
    @@buttons_pressed.any? { |i| i === 3_u8 }
  end

  def middle?
    @@buttons_pressed.any? { |i| i === 2_u8 }
  end
end
