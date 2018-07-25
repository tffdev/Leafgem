<p align="center">
	<img src="https://raw.githubusercontent.com/tfcat/Leafgem/master/logo.png">
</p>

## Description

Leafgem is the beginning of a 2D open source game engine written in Crystal.

## Run the demo project!

```
git clone https://github.com/tfcat/Leafgem.git
cd Leafgem
crystal run -s -p src/main.cr
```

## Development

What are the main things we need for a Game Engine? Here's what I can think of off the top of my head.
Each of the given features *could* be contained in a class which correlates to their purpose.

**Control**
[ ] Keypressing - *on_press*, *on_release* and *is_pressed*

**Objects**
[ ] Instance-based system. (Unique, contained object instances, derived from a template [class])

**Sprites**
[ ] Sprite animations + Breaking sprites up into sub-images

**Audio**
[ ] Oneshots
[ ] Looping background music
[ ] Audio fade in/out over time

**Maps/Rooms**
[ ] Background renderer
[ ] Tileset renderer
[ ] "Rooms", loadable, spawn objects in predetermined places

## Contributing 

I'm not all that good with Crystal - I'm creating this project as practice using the Crystal language! 

That means any and all contributions to this engine are welcome and heavily appreciated, no matter how big or small. The aim is to give creators an intuitive toolkit for making games! A bonus being a super speedy and easy engine.

Any ideas are welcome!
Fork, and work your magic!

## Contributors

- [tfcat](https://github.com/tfcat) - creator, maintainer
