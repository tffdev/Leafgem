class Leafgem::MouseManager
  @@buttons_pressed = [] of UInt8

  def self.update(event)
    if event.type.to_s.downcase.ends_with? "down"
      @@buttons_pressed.push(event.button)
    end

    @@buttons_pressed.delete event.button if event.type.to_s.downcase.ends_with? "up"
  end
end
