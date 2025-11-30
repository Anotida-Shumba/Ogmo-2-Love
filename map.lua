---@class Map
---@field draw fun()

Map = {}
Map.__index = Map

require "tile"
local json = require "dkjson"

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
	local terrain_layer = decoded_data["layers"][1]["dataCoords2D"]
	for y_cord, row in ipairs(terrain_layer) do
		for x_cord, tile in ipairs(row) do
			if tile[1] ~= -1 then
				local tile_vec2 = {x = tile[1], y = tile[2]}
				local x = (x_cord - 1) * o.tile_size
				local y = (y_cord - 1) * o.tile_size
				local position_coord = {x = o.position.x + x, y = o.position.y + y}
				local new_tile = Tile.new(position_coord, tile_vec2, o.tile_size, o.tilemap)
				o.target_world:add(new_tile, position_coord.x, position_coord.y, o.tile_size, o.tile_size) 
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