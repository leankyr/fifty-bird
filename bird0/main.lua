--[[
    GD50
    Flappy Bird Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- virtual resolution handling library
push = require 'push'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images we load into memory from files to later draw onto the screen
-- since those two are local are accesible only through this file
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

function love.load()
    -- initialize our nearest-neighbor filter so
    -- that we have no blurriness of the pixels
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize our virtual resolution
    -- {} these are the table symbol in Lua
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

-- Dynamically rescale the canvas 
-- and scale it to fit our screen
function love.resize(w, h)
    push:resize(w, h)
end

-- input from 
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- render fanction to draw the graphics (loaded images) I  guess
function love.draw()
    push:start()
    -- here we use the local variables from before the ones we loaded
    -- It takes whatever drawable and it renders it on the screen
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, 0, 0)

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end
