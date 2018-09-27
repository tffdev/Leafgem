
<p align="center">
  <img src="https://cdn.tfcat.me/leafgem_manual_images/manual.gif">
</p>

* [Getting Started](#starting)
* [Overview (How Leafgem Works)](#overview)
* [Objects](#objects)
* [Drawing](#drawing)
* [Input](#input)
* [Collision](#collision)
* [Tilemaps](#tilemaps)
* [Library Reference](#library)

# Getting Started
<a name="starting"></a>

### Dependencies
To begin your first Leafgem project, you must have installed:
* [Crystal](https://crystal-lang.org)\* - ([How to install](https://crystal-lang.org/docs/installation/))
* [libSDL2-2.0]()
* [libSDL2_mixer]()
* [libSDL2_image]()

\**make sure you meet all the dependencies needed to compile a typical Crystal program before trying to use Leafgem*

### Running an Example

To run one of our examples:

```bash
git clone https://github.com/tfcat/Leafgem.git
cd Leafgem
shards install
crystal run -s -p examples/demo/main.cr
```

### Creating your own blank project

```bash
crystal init app my_new_game
cd my_new_game
```

In `shard.yml`, add these lines:
```yaml
dependencies:
  leafgem:
    github: tfcat/leafgem
    branch: master
```

Run `shards install` to include Leafgem and SDL.cr in your project.

At the top of your project's main source file (`src/my_new_game.cr`), add `include "leafgem"`

You're ready to go!


# Overview
<a name="overview"></a>

Leafgem works in a similar way to many engines that specialize in 2D graphics. 

```crystal
require "leafgem"
include Leafgem::Library

set_window("Hello world!", 320, 240, 3)

game_run
```
<img src="https://cdn.tfcat.me/leafgem_manual_images/example.gif">

# Objects
<a name="overview"></a>

# Drawing
<a name="overview"></a>

# Input
<a name="overview"></a>

# Collision
<a name="overview"></a>

# Tilemaps
<a name="overview"></a>

# Library Reference
<a name="overview"></a>


## Game
**game_run**
Begin running the gameloop! (to be used at the end of your code)

**game_exit**
Quit the game!

**set_loop_function(function : Proc(Void)**
Will call the given function every frame BEFORE every object starts updating

**set_window(window_title : String, window_width : Int32, window_height : Int32, scale : Float32 = 1.0)**
Creates a window for our game. In order, parameters are the title of the window, the width in pixels, the height in pixels, and the scale which sprites and shapes will be drawn; for example, if set to 2.0, sprites will appear twice as big. (For best results, use an integer)
Currently, these parameters CANNOT BE MODIFIED after they have been created.



**screen_width**
GET the width of the screen in pixels

**screen_height**
GET the height of the screen in pixels

**set_fullscreen(bool)**
Sets the game to fullscreen: set_fullscreen(true), or windowed: set_fullscreen(false).


## Objects
**create_object(class, x = 0, y = 0)**
Create an instance of a given template (class) within the gameworld at the given coordinates.
Example: `create_object(Player, 100, 100)`


**destroy(object : Leafgem::Object)**
Destroys a given object. 
Example: 
```
player = create_object(Player, 100, 100)
destroy(player)
```

**get(class)**
Returns an array of IDs for every instance of a class that currently exists in the gameworld.


## Drawing
**new_spritesheet(filepath : String, tilewidth : Int32, tileheight : Int32)**
Returns a spritesheet object which is used for the built in animation engine.

**sprite(filepath : String)**
Loads an image into memory and returns an SDL::Surface

**set_draw_color(r : Int32, g : Int32, b : Int32, a : Int32 = 255)**
Sets the draw color for drawn shapes. This does not affect sprites!

**set_draw_color(color_tuple)**
A different way to set draw colors.
Example parameter: `{255,0,0,255}`

**set_background_color(r : Int32, g : Int32, b : Int32)**
Sets the color of the default background.

**fill_rect(x, y, w, h, ignore_camera = false)**
Draws a filled rectangle on the screen.

**draw_rect(x, y, w, h, ignore_camera = false)**
Draws the outline of a rectangle on the screen.

**fill_circ(x, y, r)**
Draws a filled circle on the screen, where `x` and `y` are the center of the circle.

**draw_circ(x, y, r)**
Draws a filled circle on the screen, where `x` and `y` are the center of the circle.

**draw_sprite(texture : SDL::Surface, x = 0, y = 0, alpha = 255, gui = false)**
Draws a sprite 

**draw_sprite(file : String, x = 0, y = 0, alpha = 255, gui = false)**
DESCRIPTION


## Camera
**camera**
DESCRIPTION

**camera_x**
DESCRIPTION

**camera_y**
DESCRIPTION

**set_camera_x(x)**
DESCRIPTION

**set_camera_y(y)**
DESCRIPTION


## Debug
**debug_show_hitboxes(bool)**
DESCRIPTION

**debug(text)**
DESCRIPTION


## Input
**key_pressed**
DESCRIPTION

**key**
DESCRIPTION


## Audio
**play_sound(filename : String)**
DESCRIPTION

**play_music(filename : String)**
DESCRIPTION

**fade_out_music(seconds : Float32)**
DESCRIPTION


## Math
**lerp(start, end, speed)**
DESCRIPTION

**clamp(val, min, max)**
DESCRIPTION

**sign(val)**
DESCRIPTION


## Tilemaps
**load_map(filename)**
DESCRIPTION
