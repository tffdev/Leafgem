class Leafgem::Audio
  @@soundscache = {} of String => SDL::Mix::Music

  def self.play(filename : String)
    if @@soundscache.has_key?(filename)
      @@soundscache[filename].play
    else
      @@soundscache[filename] = SDL::Mix::Music.new(filename)
      @@soundscache[filename].play
    end
  end
end
