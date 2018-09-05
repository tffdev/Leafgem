require "ini"

# TODO:
# optimise the heck outta tilemap rendering. that's a lotta sprites
# build a single surface in memory, throw to texture then render

class Leafgem::Map
  # tiles
  @@tilesheet : SDL::Texture?
  @@tiles = [] of Array(Int32)
  @@tileset_size : Vec2 = Vec2.new(0, 0)
  @@tilesize : Vec2 = Vec2.new(0, 0)
  @@mapsize : Vec2 = Vec2.new(1, 1)

  # backgrounds
  @@backgrounds = [] of SDL::Texture
  @@backgrounds_parallax = [] of Float64

  def self.loadmap(filename)
    ini = File.read(filename)
    ini = ini.gsub("=\n") { "=" }
    ini = ini.gsub(",\n") { "," }
    map = INI.parse ini

    @@backgrounds = [] of SDL::Texture
    @@backgrounds_parallax = [] of Float64

    map["backgrounds"].each do |index, bgname|
      @@backgrounds << Leafgem::AssetManager.image(bgname.split(",")[0])
      @@backgrounds_parallax.push (bgname.split(",").size > 1) ? bgname.split(",")[1].to_f : 1.0
    end

    10.times do |i|
      if (map.has_key?("layer" + i.to_s))
        @@tiles.insert(i, [] of Int32)
        map["layer" + i.to_s]["data"].split(",").each do |tile|
          @@tiles[i].push(tile.to_i)
        end
      end
    end
    @@tilesheet = Leafgem::AssetManager.image(map["tilesets"]["tileset"].split(",")[0])
    @@tilesize.x = map["tilesets"]["tileset"].split(",")[1].to_i
    @@tilesize.y = map["tilesets"]["tileset"].split(",")[2].to_i
    @@mapsize.x = map["header"]["width"].to_i
    @@mapsize.y = map["header"]["height"].to_i
    if (tilesheet = @@tilesheet)
      @@tileset_size.x = tilesheet.width / @@tilesize.x
      @@tileset_size.y = tilesheet.height / @@tilesize.y
    end
  end

  def self.tiles
    @@tiles
  end

  def self.get_tile_at(x, y, tile_layer)
    tileplace = (x/@@tilesize.x).to_i + @@mapsize.x * (y/@@tilesize.y).to_i
    if (@@tiles[tile_layer][tileplace]?)
      return @@tiles[tile_layer][tileplace]
    else
      return 0
    end
  end

  def self.draw
    # draw backgrounds
    bg_count = 0
    @@backgrounds.each_with_index do |background, bg_index|
      i = (((camera_x*(1 - @@backgrounds_parallax[bg_index])) / background.width)).to_i
      bg_x = i * background.width + @@backgrounds_parallax[bg_index] * camera_x

      while (bg_x - Leafgem::Renderer.width < camera_x)
        Leafgem::Renderer.draw(
          background,
          0, 0,
          bg_x, 0,
          background.width,
          background.height,
        )
        i += 1
        bg_count += 1
        bg_x = i * background.width + @@backgrounds_parallax[bg_index] * camera_x
      end
    end

    # draw tiles
    @@tiles.each do |tile_layer|
      tile_layer.each_with_index do |tile, i|
        if (tile != 0)
          tile -= 1
          if (sheet = @@tilesheet)
            Leafgem::Renderer.draw(
              sheet,
              (tile % @@tileset_size.x) * @@tilesize.x,
              ((tile / @@tileset_size.x).to_i) * @@tilesize.y,
              (i % @@mapsize.x) * @@tilesize.x,
              ((i / @@mapsize.x).to_i) * @@tilesize.y,
              @@tilesize.x,
              @@tilesize.y
            )
          end
        end
      end
    end
  end
end
