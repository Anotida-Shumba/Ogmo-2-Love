## What this project handles
-optimal loading of json maps produced by the Ogmo editor.  
-stores the tiles in a table for refrencing.  
-provides functions to draw the map.  

## Settings
#### for the library to work your ogmo map should have the following settings:  
&nbsp;&nbsp;&nbsp;&nbsp;-tile layer should be exported as a 2d array with Coordinates representing the tiles instead of Id's.  
  &nbsp;&nbsp;&nbsp;&nbsp;<img width="1138" height="52" alt="image" src="https://github.com/user-attachments/assets/5a3992fa-ddb0-40a5-a0f6-f20833aa7162" />  
  &nbsp;&nbsp;&nbsp;&nbsp;-the tile and map files should be in the same  location

## Usage
```lua
require "map" --first require the map file with your respective location to the file
local tilemap = love.graphics.newImage("assets/tilemap.png")
local map_position = {x = 0, y = 0} --this is the structure of all mentioned Vec2
local map = Map.new("assets/example.json", tilemap, 32, map_position) --create an instance of the Map class and pass in the parameters

-- new(json_map_path:string, love_image_for_tilemap:Image, tilesize:number, position:vec2)
```
&nbsp;&nbsp;&nbsp;&nbsp;Make sure that the path to dkjson is correct in the map file

```lua
local json = require "dkjson"
```


## Drawing
```lua
function love.draw()
    map:draw()
end
```

## Refrences
tiles are stored as instances of a tile class 
```lua
  for _, tile in ipairs(map.tiles) do 
        print(tile)
  end

  --this will print all the positions of each tile inside the map

  map.tiles[1].position.x = 100
  --with this line you can manipulate a tile's position
```

## Tiles
&nbsp;&nbsp;&nbsp;&nbsp; TIles have a vec2 position variable that can be changes to relocate tiles