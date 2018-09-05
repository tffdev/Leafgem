module Leafgem::Audio
  @@music : Pointer(LibMix::Mix_Music)?
  @@soundscache = {} of String => SDL::Mix::Sample

  def play_music(filename : String, audio_loop : Bool = false)
    @@music = LibMix.load_mus(filename)
    if music = @@music
      LibMix.play_music(music, 1)
    end
  end

  def play_sound(filename : String, audio_loop : Bool = false)
    @@soundscache[filename] = SDL::Mix::Sample.new(filename)
    SDL::Mix::Channel.play(@@soundscache[filename], 0)
  end

  def fade_out_music(seconds : Float32)
    LibMix.fade_out_music((1000 * seconds).to_i)
  end

  extend self
end
