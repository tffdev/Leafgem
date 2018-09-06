# key[0] = true for the frame it was pressed
# key[1] = true until release
class Leafgem::KeyManager
  @@keys_pressed = [] of String
  @@keys_held = [] of String

  def self.update(event)
    if event.keydown? && event.repeat.to_i == 0
      @@keys_pressed.push(event.sym.to_s.downcase)
      @@keys_held.push(event.sym.to_s.downcase)
    end

    @@keys_held.delete event.sym.to_s.downcase if event.keyup?
  end

  def self.clear_pressed
    @@keys_pressed = [] of String
  end

  def self.keys_pressed
    @@keys_pressed
  end

  def self.key_is_pressed(keycode)
    (@@keys_pressed.find { |i| i == keycode }) ? true : false
  end

  def self.key_is_held(keycode)
    (@@keys_held.find { |i| i == keycode }) ? true : false
  end
end
