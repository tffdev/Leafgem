<p align="center">
	<img src="https://tfcat.me/files/leafgemlogo.png">
</p>

## Description

Leafgem is the beginning of a 2D open source game engine written in Crystal.

## Try it out with the demo project!
```
git clone https://github.com/tfcat/Leafgem.git
cd Leafgem
shards install
crystal run -s -p demo/main.cr
```

## Development

What are the main things we need for a Game Engine? Here's what I can think of off the top of my head.
Each of the given features *could* be contained in a class which correlates to their purpose.

**Control**
- [x] Keypressing - *on_press*, *on_release* and *is_pressed*

**Objects**
- [x] Instance-based system. (Unique, contained object instances, derived from a template [class])
- [ ] Destroying objects
- [ ] Object selection (e.g. setting attributes of foreign objects )

**Sprites**
- [x] Sprite animations + Breaking sprites up into sub-images

**Audio**
- [x] Oneshots
- [x] Looping background music
- [x] Audio fade in/out over time

**Maps/Rooms**
- [ ] Background renderer
- [ ] Tileset renderer
- [ ] "Rooms", loadable, spawn objects in predetermined places

## Contributing 

I'm not all that good with Crystal - I'm creating this project as practice using the Crystal language! 

That means any and all contributions to this engine are welcome and heavily appreciated, no matter how big or small. The aim is to give creators an intuitive toolkit for making games! A bonus being a super speedy and easy engine.

Any ideas are welcome!
Fork, and work your magic!

## Contributors

- [tfcat](https://github.com/tfcat) - creator, maintainer, designer
- [rx14](https://github.com/rx14) - mentor, sensei, tech and emotional support