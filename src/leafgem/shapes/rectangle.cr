class Leafgem::Shapes::Rectangle < Leafgem::GameObject
  property fill = true
  property outline = false

  def self.draw(position : Vec, size : Vec, fill = true, outline = false)
    draw_self(position, size)
  end

  def draw_self(position : Vec = @position, size : Vec = @size, fill = @fill, outline = @outline)
    if (renderer = Leafgem::Renderer.renderer)
      position = position.to_i

      rect = SDL::Rect.new(position.x, position.y, size.x, size.y)
      Leafgem::Draw.fill_rect(rect) if fill
      Leafgem::Draw.draw_rect(rect) if outline
    end
  end
end
