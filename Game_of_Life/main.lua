--[[
    Game of life, a cellular automaton game that simulates the appearence of complex behaviour in a system guverned by symple rules.

    Rules:
        1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
        2. Any live cell with two or three live neighbours lives on to the next generation.
        3. Any live cell with more than three live neighbours dies, as if by overpopulation.
        4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
]]

-- import the cell class
Cell = require 'cell'

-- cell variables
CELL_WIDTH = 10
CELL_HEIGHT = 10
CELL_STATE = false

-- window variables
-- Note: dimensions must be multiples of CELL_WIDTH, CELL_HEIGHT in order to allign the cells to the screen
WINDOW_WIDTH = 1280                -- 1280 / 10 = 128
WINDOW_HEIGHT = 720                 -- 720 / 10 = 72

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

    -- initialize the grid with dead cells
    grid = {}
    for y = 0, ((WINDOW_HEIGHT / CELL_HEIGHT)-1), 1 do
        grid[y] = {}
        for x = 0, ((WINDOW_WIDTH / CELL_WIDTH)-1), 1 do
            grid[y][x] = Cell:new(y*CELL_WIDTH,x*CELL_HEIGHT, CELL_STATE)
        end
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
            love.window.setTitle('Game of Life')
        elseif GAME_STATE == 'start' then
            GAME_STATE = 'paused'
            love.window.setTitle('*Paused*')
        end
    end

    -- clear the grid
    if key == 'c' then
        for y = 0, ((WINDOW_HEIGHT / CELL_HEIGHT)-1), 1 do
            for x = 0, ((WINDOW_WIDTH / CELL_WIDTH)-1), 1 do
                grid[y][x].state = false
            end
        end
    end

    -- randomise the grid with another arrangement
    if key == 'r' then
        for y = 1, ((WINDOW_HEIGHT / CELL_HEIGHT)-2), 1 do
            for x = 1, ((WINDOW_WIDTH / CELL_WIDTH)-2), 1 do
                if love.math.random(0, 1) == 1 then
                    grid[y][x].state = true
                else
                    grid[y][x].state = false
                end
            end
        end
    end
end

-- get coords of mouse and bind them to variables
MOUSE_X = love.mouse.getX()
MOUSE_Y = love.mouse.getY()
-- detect a click using the variables above
function love.mousepressed(MOUSE_X, MOUSE_Y, button)
    if button == 1 then
        -- change state of mouse cursor selected cell
        grid[math.floor(MOUSE_Y / CELL_HEIGHT)][math.floor(MOUSE_X / CELL_WIDTH)]:flip_state()
    end
end

function love.update(dt)
    -- only run the simulation if the game isn't paused
    if GAME_STATE == 'start' then
        -- slow down the update process in order to make seeing the state change of the cell much easier
        love.timer.sleep(0.1)

        -- create a temporary grid that will store the next generation of cells
        temp_grid = {}
        for y = 0, ((WINDOW_HEIGHT / CELL_HEIGHT)-1), 1 do
            temp_grid[y] = {}
            for x = 0, ((WINDOW_WIDTH / CELL_WIDTH)-1), 1 do
                temp_grid[y][x] = Cell:new(y*CELL_WIDTH,x*CELL_HEIGHT, CELL_STATE)
            end
        end

        -- check all the cells from the grid and update the temporary grid accordingly
        for y = 1, ((WINDOW_HEIGHT / CELL_HEIGHT)-2), 1 do
            for x = 1, ((WINDOW_WIDTH / CELL_WIDTH)-2), 1 do
                -- the 8 cells that surround the current cell we are checking
                adjacent_cells = {
                    grid[y-1][x-1], grid[y-1][x], grid[y-1][x+1],
                    grid[y][x-1],                 grid[y][x+1],
                    grid[y+1][x-1], grid[y+1][x], grid[y+1][x+1]
                }
                alive_adjacent_cells = count_adjacent_cells(adjacent_cells)

                -- Rule Implementation
                -- if a dead cell is surrounded by 3 cells that are alive it too becomes alive
                if grid[y][x].state == false and alive_adjacent_cells == 3 then
                    temp_grid[y][x]:flip_state()

                -- if a cell that is alive is surroundedby 2 or 3 alive cells it remains alive
                elseif grid[y][x].state == true and (alive_adjacent_cells == 3 or alive_adjacent_cells == 2) then
                    temp_grid[y][x]:flip_state()
                end
            end
        end

        -- copy the updated cells back into the original grid for rendering
        for y = 0, ((WINDOW_HEIGHT / CELL_HEIGHT)-1), 1 do
            for x = 0, ((WINDOW_WIDTH / CELL_WIDTH)-1), 1 do
                grid[y][x] = temp_grid[y][x]
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

-- count the amount of alive cells from a given table
function count_adjacent_cells(cell_table)
    counter = 0
    for key, values in pairs(cell_table) do
        if values.state == true then
            counter = counter + 1
        end
    end
    return counter
end
