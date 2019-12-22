--[[
    Class for the Ant entity
    It has an x and y value
    The Ant can also face one of the 4 cardinal directions: North, South, East and West
]]


Ant = {}
Ant.__index = Ant
-- initialise an ant
function Ant:new(y, x, facing)
    local this = {
        y = y or 0,
        x = x or 0,
        facing = facing or 'north'
    }
    setmetatable(this, self)
    return this
end
-- move the Ant forward in respect to it's direction
function Ant:forward()
    if self.facing == 'north' then
        self.y = self.y - 1
    elseif self.facing == 'south' then
        self.y = self.y + 1
    elseif self.facing == 'east' then
        self.x = self.x + 1
    elseif self.facing == 'west' then
        self.x = self.x - 1
    end
end
-- change the direction of the Ant 90° left
function Ant:turn_left()
    if self.facing == 'north' then
        self.facing = 'west'
    elseif self.facing == 'west' then
        self.facing = 'south'
    elseif self.facing == 'south' then
        self.facing = 'east'
    elseif self.facing == 'east' then
        self.facing = 'north'
    end
end
-- change the direction of the Ant 90° right
function Ant:turn_right()
    if self.facing == 'north' then
        self.facing = 'east'
    elseif self.facing == 'east' then
        self.facing = 'south'
    elseif self.facing == 'south' then
        self.facing = 'west'
    elseif self.facing == 'west' then
        self.facing = 'north'
    end
end

return Ant
