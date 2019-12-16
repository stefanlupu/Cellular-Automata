--[[
    Class for each cell
    It has a x value, a y value, a widht and a height
    as well as a state which can either be alive or dead
]]

CELL_WIDTH = 10
CELL_HEIGHT = 10

Cell = {}
Cell.__index = Cell
-- initialise a cell
function Cell:new(y, x, state)
    local this = {
        y = y or 0,
        x = x or 0,
        state = state or false
    }
    setmetatable(this, self)
    return this
end
-- change the state of the cell from dead to alive and vice versa
function Cell:flip_state()
    self.state = not self.state
end
-- render the cell on screen
function Cell:render()
    if self.state == true then
        love.graphics.rectangle('fill', self.x, self.y, CELL_WIDTH, CELL_HEIGHT)
    end
end

return Cell
