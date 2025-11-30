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