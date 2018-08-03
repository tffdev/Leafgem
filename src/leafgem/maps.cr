require "ini"

class Leafgem::Map
  @@tilesheet : SDL::Texture?
  @@tileset_width : Int32 = 0
  @@tileset_height : Int32 = 0
  @@tiles = [] of Int32
  @@tilesize_x : Int32 = 0
  @@tilesize_y : Int32 = 0
  @@mapsize_x : Int32 = 1
  @@mapsize_y : Int32 = 1

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
    map["layer"]["data"].split(",").each do |tile|
      @@tiles << tile.to_i
    end
    @@tilesheet = sprite(map["tilesets"]["tileset"].split(",")[0])
    @@tilesize_x = map["tilesets"]["tileset"].split(",")[1].to_i
    @@tilesize_y = map["tilesets"]["tileset"].split(",")[2].to_i
    @@mapsize_x = map["header"]["width"].to_i
    @@mapsize_y = map["header"]["height"].to_i
    if (tilesheet = @@tilesheet)
      @@tileset_width = tilesheet.width/@@tilesize_x
      @@tileset_height = tilesheet.height/@@tilesize_y
    end
  end

  def self.draw
    i = 0
    @@tiles.each do |tile|
      tile -= 1
      if (tile != -1)
        if (sheet = @@tilesheet)
          Leafgem::Game.renderer.copy(
            sheet,
            SDL::Rect.new(
              (tile % @@tileset_width)*@@tilesize_x,
              ((tile / @@tileset_height).to_i)*@@tilesize_y,
              @@tilesize_x, @@tilesize_y),
            SDL::Rect.new(
              (i % @@mapsize_x)*@@tilesize_x - Leafgem::Game.camera_x,
              ((i/@@mapsize_y).to_i)*@@tilesize_y - Leafgem::Game.camera_y,
              @@tilesize_x,
              @@tilesize_y
            ),
          )
        end
      end
      i += 1
    end
  end
end
