# key[0] = true for the frame it was pressed
# key[1] = true until release
class Leafgem::KeyManager
  @@keys_pressed = {} of String => Array(Bool)

  def self.update(event)
    if event.keydown? && event.repeat.to_i == 0
      @@keys_pressed[event.sym.to_s.downcase] = [true, true]
    end
    if event.keyup?
      @@keys_pressed[event.sym.to_s.downcase][1] = false
    end
  end

  def self.clear_pressed
    @@keys_pressed.each do |key, value|
      value[0] = false
    end
  end

  def self.keys_pressed
    @@keys_pressed
  end
end
