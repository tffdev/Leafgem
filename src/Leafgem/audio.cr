class Leafgem::Audio
  @@soundscache = {} of String => SDL::Mix::Sample

  def self.play(filename : String, audio_loop : Bool = false)
    if !@@soundscache.has_key?(filename)
      @@soundscache[filename] = SDL::Mix::Sample.new(filename)
    end
    SDL::Mix::Channel.play(@@soundscache[filename], (audio_loop) ? -1 : 0)
  end
end
