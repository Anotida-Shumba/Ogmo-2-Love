require "map"

---@class Vec2
---@field x number
---@field y number

local tilemap = love.graphics.newImage("assets/tilemap.png")
local map_position = {x = 0, y = 0}
local map = Map.new("assets/example.json", tilemap, 32, map_position)

function love.load()
    for _, tile in ipairs(map.tiles) do 
        print(tile)
    end
end


function love.draw()
    map:draw()
end