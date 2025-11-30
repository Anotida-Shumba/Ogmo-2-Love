---@class Chunk
---@field draw fun()
---@field remove_chunk fun()

Chunk = GameObject:extend()
require "src.chunking.tile"
local json = require "libs.dkjson"

---@param target_world World
---@param position Vec2
---@param tilemap "love.image"
---@param tilesize number
---@param chunk_path string
function Chunk:new(target_world, position, tilemap, tilesize, chunk_path)
  self.background = Sprite.new({image = "assets/background.ong.png"})
  self.background.scale = Vec2.new(2, 2)
  self.position = position
  self.background_pos = position + Vec2.new(0, -10)
  local file = love.filesystem.read(chunk_path)
  local decoded_data = json.decode(file)
  self.tilemap = tilemap
  self.tile_size = tilesize
  self.tiles = {}
  self.breakable_tiles = {}
  self.target_world = target_world

  ---@diagnostic disable-next-line: need-check-nil
  local terrain_layer = decoded_data["layers"][1]["dataCoords2D"]
  for y_cord, row in ipairs(terrain_layer) do
    for x_cord, tile in ipairs(row) do
      -- self.tiles[key] = Tile(decoded_data.tile_size , value.tile_coords.x , value.tile_coords.y , value.x , value.y , self.image)
      if tile[1] ~= -1 then
        local tile_vec2 = Vec2.new(tile[1], tile[2])
        local x = (x_cord - 1) * self.tile_size
        local y = (y_cord - 1) * self.tile_size
        local position_coord = self.position +  Vec2.new(x, y)
        local new_tile = Tile(position_coord, tile_vec2, self.tile_size, self.tilemap)
        self.target_world:add(new_tile, position_coord.x, position_coord.y, self.tile_size, self.tile_size) 
        table.insert(self.tiles, new_tile)
      end
    end
   end

---@diagnostic disable-next-line: need-check-nil
  local breakable_layer = decoded_data["layers"][2]["dataCoords2D"]
  for y_cord, row in ipairs(breakable_layer) do
    for x_cord, tile in ipairs(row) do
      -- self.tiles[key] = Tile(decoded_data.tile_size , value.tile_coords.x , value.tile_coords.y , value.x , value.y , self.image)
      if tile[1] ~= -1 then
        local tile_vec2 = Vec2.new(tile[1], tile[2])
        local x = (x_cord - 1) * self.tile_size
        local y = (y_cord - 1) * self.tile_size
        local position_coord = self.position +  Vec2.new(x, y)
        local new_tile = Tile(position_coord, tile_vec2, self.tile_size, self.tilemap, true, self.target_world, self.breakable_tiles)
        self.target_world:add(new_tile, position_coord.x, position_coord.y, self.tile_size, self.tile_size) 
        table.insert(self.breakable_tiles, new_tile)
      end
    end
   end

---@diagnostic disable-next-line: need-check-nil
   local safe_point_layer = decoded_data["layers"][3]["entities"][1]
   self.safe_point = self.position + Vec2.new(safe_point_layer["x"], safe_point_layer["y"])
end

function Chunk:update(dt)
  for index, tile in ipairs(self.breakable_tiles) do
    tile:update(dt)
  end
end

function Chunk:set_location(location)
  for index, tile in ipairs(self.tiles) do
    local result_x, result_y, collisions, len  = self.target_world:move(tile, location.x, location.y, function ()
      return nil
    end)
    self.position.x = result_x
    self.position.y = result_y
  end
end

function Chunk:remove_chunk()
  for index, tile in ipairs(self.tiles) do
    self.target_world:remove(tile)
  end
  self.tiles = {}
  
  for index, tile in ipairs(self.breakable_tiles) do
    self.target_world:remove(tile)
  end
  self.breakable_tiles = {}
end

function Chunk:draw()
  love.graphics.setColor(1, 1, 1, 0.2)
  self.background:draw(self.background_pos)
  love.graphics.setColor(Color())
  ---@param tile Tile
  for index, tile in ipairs(self.tiles) do
    tile:draw()
  end

  for index, tile in ipairs(self.breakable_tiles) do
    tile:draw()
  end
end