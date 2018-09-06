# This is just the code to show the fading title!
class Scene_manager < Leafgem::GameObject
  @titlefade = 0.0
  @titleswitch = false
  @title_sprite : SDL::Texture?

  def init
    @title_sprite = sprite("examples/demo/images/title.png")
  end

  def update
    if (@titleswitch)
      @titlefade = Math.max(@titlefade - 0.01, 0).to_f
    else
      @titlefade = Math.min(@titlefade + 0.01, 1).to_f
    end
    if (get(Player).size > 0 && get(Player)[0].position.x > 150)
      @titleswitch = true
    end
  end

  def draw
    if (sprite = @title_sprite)
      draw_sprite(sprite, 32 + (screen_width - sprite.width)/2, 50, @titlefade)
    end
  end
end
