require "ini"

# TODO:
# optimise the heck outta tilemap rendering. that's a lotta sprites
# build a single surface in memory, throw to texture then render

class Leafgem::Map
  @@tilesheet : SDL::Texture?
  @@tileset_width : Int32 = 0
  @@tileset_height : Int32 = 0
  @@tiles = [] of Int32
  @@tilesize_x : Int32 = 0
  @@tilesize_y : Int32 = 0
  @@mapsize_x : Int32 = 1
  @@mapsize_y : Int32 = 1
  @@backgrounds = [] of SDL::Texture
  @@backgrounds_parallax = [] of Float64

  def self.tilesheet=(tilesheet)
    @@tilesheet
  end

  def self.tiles=(tiles)
    @@tiles
  end

  def self.loadmap(filename)
    ini = File.read(filename)
    ini = ini.gsub("=\n") { "=" }
    ini = ini.gsub(",\n") { "," }
    map = INI.parse ini

    @@backgrounds = [] of SDL::Texture
    @@backgrounds_parallax = [] of Float64

    map["backgrounds"].each do |index, bgname|
      @@backgrounds << Leafgem::AssetManager.image(bgname.split(",")[0])
      @@backgrounds_parallax << bgname.split(",")[1].to_f
    end

    map["layer"]["data"].split(",").each do |tile|
      @@tiles << tile.to_i
    end
    puts "loading map"
    @@tilesheet = Leafgem::AssetManager.image(map["tilesets"]["tileset"].split(",")[0])
    @@tilesize_x = map["tilesets"]["tileset"].split(",")[1].to_i
    @@tilesize_y = map["tilesets"]["tileset"].split(",")[2].to_i
    @@mapsize_x = map["header"]["width"].to_i
    @@mapsize_y = map["header"]["height"].to_i
    if (tilesheet = @@tilesheet)
      @@tileset_width = tilesheet.width / @@tilesize_x
      @@tileset_height = tilesheet.height / @@tilesize_y
    end
  end

  def self.draw
    bgcount = 0
    @@backgrounds.each do |background|
      # puts "#{background} #{i}"
      i = ((camera_x - background.width * @@backgrounds_parallax[bgcount] - Leafgem::Renderer.width) / Leafgem::Renderer.width).to_i
      bg_x = i * background.width + @@backgrounds_parallax[bgcount] * camera_x
      while (bg_x - Leafgem::Renderer.width < camera_x)
        Leafgem::Renderer.draw(
          background,
          0, 0,
          bg_x,
          0,
          background.width,
          background.height,
        )
        i += 1
        bg_x = i * background.width + @@backgrounds_parallax[bgcount] * camera_x
      end
      bgcount += 1
    end

    i = 0
    @@tiles.each do |tile|
      if (tile != 0)
        tile -= 1
        if (sheet = @@tilesheet)
          # zoinks!
          Leafgem::Renderer.draw(
            sheet,
            (tile % @@tileset_width) * @@tilesize_x,
            ((tile / @@tileset_width).to_i) * @@tilesize_y,
            (i % @@mapsize_x) * @@tilesize_x,
            ((i / @@mapsize_x).to_i) * @@tilesize_y,
            @@tilesize_x,
            @@tilesize_y
          )
        end
      end
      i += 1
    end
    Leafgem::Renderer.draw(
      @@backgrounds[2],
      200, 200, 0, 0, 200, 200, true
    )
  end
end
