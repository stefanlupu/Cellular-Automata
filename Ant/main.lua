--[[
    Langton's Ant, a cellular automaton game invented in 1986 with a very simple set of rules but complex emergent behavior.

    Rules:
        * at a white square, turn 90° right, flip the color of the square, move forward one unit
        * at a black square, turn 90° left, flip the color of the square, move forward one unit
]]

-- import the cell and ant classes
Cell = require 'cell'
Ant = require 'ant'

-- cell variables
CELL_WIDTH = 5
CELL_HEIGHT = 5


-- ant variables
TOTAL_ANTS = 20
directions = {
    'north',
    'east',
    'south',
    'west'
}

-- window variables
-- Note: dimensions must be multiples of CELL_WIDTH, CELL_HEIGHT in order to allign the cells to the screen
WINDOW_WIDTH = 1280                -- 1280 / 5 = 256
WINDOW_HEIGHT = 720                 -- 720 / 5 = 144

GAME_STATE = 'paused'

function love.load()
    -- initialize the window
    love.window.setTitle('*Paused*')

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    end

    -- initialise the grid with dead cells
    grid = {}
    for y = 0, ((WINDOW_HEIGHT/CELL_HEIGHT)-1), 1 do
        grid[y] = {}
        for x = 0, ((WINDOW_WIDTH/CELL_WIDTH)-1), 1 do
            grid[y][x] = Cell:new(y*CELL_WIDTH,x*CELL_HEIGHT)
        end
    end

    -- create a set of random ants
    ants = {}
    for i=0, TOTAL_ANTS-1, 1 do
        y = love.math.random(0, WINDOW_HEIGHT/CELL_HEIGHT-1)
        x = love.math.random(0, WINDOW_WIDTH/CELL_WIDTH-1)
        random_direction = love.math.random(0,4)
        table.insert(ants, Ant:new(y, x, directions[random_direction]))
    end

function love.keypressed(key)
    -- close window using the escape key
    if key == 'escape' then
        love.event.quit()
    end

    -- pause/unpause the game by pressing space
    if key == 'space' then
        if GAME_STATE == 'paused' then
            GAME_STATE = 'start'
            love.window.setTitle('Langton\'s Ant')
        elseif GAME_STATE == 'start' then
            GAME_STATE = 'paused'
            love.window.setTitle('*Paused*')
        end
    end

    -- randomise the grid with another set of ants
    if key == 'r' then
        -- clear the grid
        for y = 0, ((WINDOW_HEIGHT / CELL_HEIGHT)-1), 1 do
            for x = 0, ((WINDOW_WIDTH / CELL_WIDTH)-1), 1 do
                grid[y][x].state = false
            end
        end

        -- create another set of random ants
        ants = {}
        for i=0, TOTAL_ANTS-1, 1 do
            y = love.math.random(0, WINDOW_HEIGHT/CELL_HEIGHT-1)
            x = love.math.random(0, WINDOW_WIDTH/CELL_WIDTH-1)
            random_direction = love.math.random(0,4)
            table.insert(ants, Ant:new(y, x, directions[random_direction]))
        end
    end
end

function love.update(dt)
    -- only run the simulation if the game isn't paused
    if GAME_STATE == 'start' then
        -- implementation of rules
        -- the chains of 'and' statements are there to ensure the ant stays inside the bounding box that is the screen
        for key, value in pairs(ants) do
            if grid[value.y][value.x].state == true and 0 < value.y and value.y < (WINDOW_HEIGHT/CELL_HEIGHT-1) and 0 < value.x and value.x < (WINDOW_WIDTH/CELL_WIDTH-1)  then
                value:turn_right()
                grid[value.y][value.x]:flip_state()
                value:forward()
            elseif grid[value.y][value.x].state == false and 0 < value.y and value.y < (WINDOW_HEIGHT/CELL_HEIGHT-1) and 0 < value.x and value.x < (WINDOW_WIDTH/CELL_WIDTH-1) then
                value:turn_left()
                grid[value.y][value.x]:flip_state()
                value:forward()
            end
        end
    end
end

-- draw all the cells from the grid
function love.draw()
    for y = 0, ((WINDOW_HEIGHT / CELL_HEIGHT)-1), 1 do
        for x = 0, ((WINDOW_WIDTH / CELL_WIDTH)-1), 1 do
            grid[y][x]:render()
        end
    end
end
