class Player < Thing
  def update
    @current_sprite += 0.06
    if (@current_sprite > 4)
      @current_sprite = 0
    end
  end

  def draw
    RENDERER.copy(@spritesheet, @quads[@current_sprite.to_i], @sprquad)
  end
end
