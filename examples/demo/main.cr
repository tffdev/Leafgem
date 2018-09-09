require "../../src/leafgem"
include Leafgem::Library

require "./scene_manager"

class Player < Leafgem::Objects::Game
  # animations: [[start_col, end_col], row, speed]
  Anim::Idle = [[0, 1], 0, 0.05]
  Anim::Walking = [[2, 3], 0, 0.1]
  Anim::JumpUp = [0, 1, 0]
  Anim::JumpDown = [1, 1, 0]

  @doublejump = false
  @gravity = 0.2
  @max_mvspeed = 1
  # stuff for physics
  @xvel = 0.0
  @yvel = 0.0
  @x_counter = 0.0
  @y_counter = 0.0
  @x_cnt = 0.0
  @y_cnt = 0.0
  @onground = false

  def create
    set_spritesheet("examples/demo/images/cat.png", 27, 27)
    set_animation(Anim::Idle)
    set_hitbox(8, 12, 10, 14)
    @sprite_xscale = 1
  end

  def update
    debug @xvel
    debug @yvel

    self.move
    self.collide
    self.setanim
    set_camera_x(lerp(camera_x, Math.max(pos.x - 90, 0), 0.05))
  end

  def draw
    draw_self
    set_draw_color(255, 0, 0, 100)
    # fill_circ(Mouse.world_position.x, Mouse.world_position.y, 2)
  end

  def move
    debug key? "left"

    @xvel -= 1 if key? "left"
    @xvel += 1 if key? "right"
    @yvel = -4 if (key?("space") && @onground)

    if (key_pressed?("space") && !@onground && @doublejump)
      @yvel = -4
      @doublejump = false
      10.times do
        create_object(Sparkle, pos.x, pos.y)
      end
    end
  end

  def setanim
    set_animation(Anim::Idle) if @onground && @xvel.abs < 0.1
    set_animation(Anim::Walking) if @onground && @xvel.abs > 0.1
    set_animation(Anim::JumpUp) if !@onground && @yvel < 0
    set_animation(Anim::JumpDown) if !@onground && @yvel > 0
  end

  # physics
  def collide
    @x_counter += @xvel
    @y_counter += @yvel
    @x_cnt = (@x_counter + 0.5).floor
    @y_cnt = (@y_counter + 0.5).floor
    @x_counter -= @x_cnt
    @y_counter -= @y_cnt
    @yvel += @gravity

    if ((@xvel.abs > 0.01))
      @xvel /= 1.5
    else
      @xvel = 0
    end
    if ((@xvel.abs) > @max_mvspeed)
      @xvel = @max_mvspeed*sign(@xvel)
    end

    hh = @x_cnt.abs
    while (hh > 0)
      hh -= 1
      if (@hitbox.meeting_tile_layer?(sign(@x_cnt), 0, 0))
        @xvel = 0
        break
      else
        if (@onground && !@hitbox.meeting_tile_layer?(sign(@x_cnt), 1, 0) && @hitbox.meeting_tile_layer?(sign(@x_cnt), 2, 0))
          @pos.y += 1
        end
        @pos.x += sign(@x_cnt)
      end
    end

    vv = @y_cnt.abs
    while (vv > 0)
      vv -= 1
      if (@yvel <= 0)
        if (@hitbox.meeting_tile_layer?(0, sign(@y_cnt), 0))
          @yvel = 0
          break
        else
          @pos.y += sign(@y_cnt)
        end
      elsif (@hitbox.meeting_tile_layer?(0, 1, 0))
        @yvel = 0
        break
      else
        @pos.y += sign(@y_cnt)
      end
    end

    if (@hitbox.meeting_tile_layer?(0, 1, 0))
      @onground = true
      @doublejump = true
    else
      @onground = false
    end
  end
end

class Sparkle < Leafgem::Objects::Game
  @circle_size : Float64 = Random.rand*4
  @vel = Vec2(Float64).new((Random.rand - 0.5)*2, (Random.rand - 0.2)*2)

  def update
    @pos.x += @vel.x /= 1.1
    @pos.y += @vel.y /= 1.1
    @circle_size -= 0.1
    if (@circle_size <= 0)
      destroy
    end
  end

  def draw
    set_draw_color(255, 255, 255, 255)
    Leafgem::Draw.fill_circ(pos.x + 10, pos.y + 27, @circle_size)
  end
end

set_window("Leafgem Demo!", 560, 400, 2)

load_map("examples/demo/map")
create_object(Scene_manager, 0, 0)
create_object(Player, 122, 100)
set_camera_x(32)

Leafgem::Game.run
