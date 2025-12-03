---@class Tile
---@field position Vec2
---@field draw fun(self:Tile)

Tile = {}
Tile.__index = Tile

---@return Tile
---@param position Vec2
---@param tile_coords Vec2
---@param tilesize any
---@param tilemap any
function Tile.new(position, tile_coords, tilesize, tilemap)
    local o = {}
    setmetatable(o, Tile)
    o.position = position
    o.tilesize = tilesize
    o.tile_coords = tile_coords
    o.tilemap = tilemap
    o.quad = love.graphics.newQuad(o.tile_coords.x * o.tilesize , o.tile_coords.y * o.tilesize , o.tilesize , o.tilesize , o.tilemap)
    return o
end

function Tile:draw()
    love.graphics.draw(self.tilemap , self.quad , self.position.x, self.position.y)
end

---@class Map
---@field draw fun()

Map = {}
Map.__index = Map

-- require "tile"
local json = require "dkjson" --path to dkjson

---@return Map
---@param position Vec2
---@param tilemap "love.image"
---@param tile_size number
---@param map_path string
function Map.new(map_path, tilemap, tile_size, position)
	local o = {}
	setmetatable(o, Map)
	o.position = position
	local file = love.filesystem.read(map_path)
	local decoded_data = json.decode(file)
	o.tilemap = tilemap
	o.tile_size = tile_size
	o.tiles = {}

	---@diagnostic disable-next-line: need-check-nil
	local terrain_layer = decoded_data["layers"][1]["dataCoords2D"] --layer containing tile information
	for y_cord, row in ipairs(terrain_layer) do
		for x_cord, tile in ipairs(row) do
			if tile[1] ~= -1 then
				local tile_vec2 = {x = tile[1], y = tile[2]}
				local x = (x_cord - 1) * o.tile_size
				local y = (y_cord - 1) * o.tile_size
				local position_coord = {x = o.position.x + x, y = o.position.y + y}
				local new_tile = Tile.new(position_coord, tile_vec2, o.tile_size, o.tilemap)
				table.insert(o.tiles, new_tile)
			end
		end
	end

	return o
end

function Map:draw()
  ---@param tile Tile
  for index, tile in ipairs(self.tiles) do
    tile:draw()
  end
end