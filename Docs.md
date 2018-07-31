
# Leafgem Docs

## Contents:

### Game
create_window(window_title : String, window_width : Int32, window_height : Int32, scale : Float32)
set_loop_function(function : Proc(Void))

### Objects
create_object(thing, x = 0, y = 0)
new_spritesheet(filepath : String, tilewidth : Int32, tileheight : Int32)

### Drawing
draw_sprite(filename : String, x : Float32 = 0, y : Float32 = 0, alpha : Float32 = 1)

### Control
keyboard_check_pressed(keycode : String)
keyboard_check(keycode : String)

### Maps

flare map files