# ======================== #
#         LIBRARY          #
# ======================== #
# Beginning of the publically accessible library,
# all the goofy global functions that are
# essentially simple wrappers around less intuitive
# actions.

def create_object(thing, x = 0, y = 0)
  # Give objects a unique identifier on create?
  a = thing.new
  a.x = x
  a.y = y
  a.init
  Leafgem::Game.loop << a
end

def key_pressed(keycode)
end

def set_loopfunc(function)
  Leafgem::Game.set_loopfunc(function)
end
