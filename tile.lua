---@class Tile
---@field position Vec2
---@field tilesize Vec2
---@field tile_coords Vec2
---@field draw fun()

Tile = GameObject:extend()

---@param position Vec2
---@param tile_coords Vec2
---@param tilesize Vec2
---@param tilemap "love.image"
---@param breakable boolean|nil
---@param target_world World
---@param breakable_table {}
function Tile:new(position, tile_coords, tilesize, tilemap, breakable, target_world, breakable_table)
    Tile.super.new(self, "terrain")
    self.position = position
    self.draw_pos = Vec2.new(0, 0)
    self.tilesize = tilesize
    self.tile_coords = tile_coords
    self.tilemap = tilemap
    self.quad = love.graphics.newQuad(self.tile_coords.x * self.tilesize , self.tile_coords.y * self.tilesize , self.tilesize , self.tilesize , self.tilemap)
    self.breakable = breakable
    self.target_world = target_world
    self.break_timer = Timer.new()
    self.collider_delay = Timer.new()
    self.tile_state = FSM(self, self.idle)
    self.drop_velocity = 0
    self.shake_power = 40
    self.touched = false
    self.breakable_table = breakable_table
end

function Tile:update(dt)
    if self.breakable == false or self.breakable == nil then
        return
    end
    self.tile_state:update(dt)
end

function Tile:idle(dt)
    self.break_timer:update(dt)
    -- self.draw_pos.x = self.position.x + 10 * dt
    self.draw_pos.x = self.position.x + math.random(-1, 1) * self.shake_power * dt
    self.draw_pos.y = self.position.y + math.random(-1, 1) * self.shake_power * dt

    local top_collisions = self.target_world:queryRect(self.position.x, self.position.y - 3, self.tilesize , 3, function (item)
        return item.type == "player"
    end)

    if #top_collisions > 0 then
        self.touched = true
        self.break_timer:start(0.5, function ()
            self.tile_state:change_state(self.broken)
            self.collider_delay:start(0.2, function ()
                self.type = "broken"
            end)
        end)
    end
    if self.touched == true then
        self.shake_power = math.min(self.shake_power + 200 * dt, 100)
    end
end

function Tile:broken(dt)
    self.collider_delay:update(dt)
    self.drop_velocity = self.drop_velocity + 1300 * dt
    self.draw_pos.y = self.draw_pos.y + self.drop_velocity * dt 
end

function Tile:draw()
    if self.breakable then
        if self.tile_state.current_state == self.broken then
            love.graphics.setColor(Color("#f1164b"))
        end
        love.graphics.draw(self.tilemap , self.quad , self.draw_pos.x, self.draw_pos.y)
        -- love.graphics.rectangle('line', self.position.x, self.position.y - 3, self.tilesize , 3)
    else
        love.graphics.draw(self.tilemap , self.quad , self.position.x, self.position.y)
    end
    love.graphics.setColor(Color())
end