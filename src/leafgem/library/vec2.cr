require "../util/vec2"

# NOTE: this is seperate file but not really I made a mess
struct Leafgem::Util::Vec2(T)
  def relative_to_world
    self.relative_to_world(Leafgem::Renderer.scale, Leafgem::Renderer.offset, Leafgem::Renderer.camera.pos)
  end
end
