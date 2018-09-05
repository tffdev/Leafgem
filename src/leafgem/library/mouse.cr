require "../mouse/mouse"

# The mouse library helps deal and interact with mouse events
#
# Example of the mouse library:
#
# ```
# Mouse.primary.position.x
# ```
#
# The above can produce:
#
# ```text
# 33
# ```
module Leafgem::Library::Mouse
  include Leafgem::Mouse::Mouse

  extend self
end
