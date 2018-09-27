<p align="center">
  <img src="https://cdn.tfcat.me/leafgem_manual_images/manual.gif">
</p>


# Contents

* [Overview (How Leafgem Works)](#overview)
* [Objects](#objects)
* [Drawing](#drawing)
* [Input](#input)
* [Collision](#collision)
* [Tilemaps](#tilemaps)

<hr>

## Getting started

### Dependencies
To begin your first Leafgem project, you must have installed:
* [Crystal](https://crystal-lang.org) - ([How to install](https://crystal-lang.org/docs/installation/))\*
* [libSDL2-2.0]()
* [libSDL2_mixer]()
* [libSDL2_image]()

\* *make sure you meet all the dependencies needed to compile a typical Crystal program before trying to use Leafgem*

### Running examples

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


<h1 id="overview">Overview</h1>

Leafgem works in a similar way to many engines that specialize in 2D graphics. 

```crystal
require "leafgem"
include Leafgem::Library

set_window("Hello world!", 320, 240, 3)

game_run
```

<img src="https://cdn.tfcat.me/leafgem_manual_images/example.gif">