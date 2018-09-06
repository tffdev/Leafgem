class Leafgem::Shapes::Rectangle < Leafgem::GameObject
  property fill = true
  property outline = false

  def draw_self(position : Vec = @position, size : Vec = @size)
    if (renderer = Leafgem::Renderer.renderer)
      position = position.to_i

      rect = SDL::Rect.new(position.x, position.y, size.x, size.y)
      renderer.fill_rect(rect) if @fill
      renderer.draw_rect(rect) if @outline
    end
  end
end
