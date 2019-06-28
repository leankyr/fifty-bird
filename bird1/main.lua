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

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
-- we need this to know how much we want the background to scroll
-- if the value is 0 we get no background scroll
-- We also want to scroll just the x axis
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
-- same applies for the ground
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
-- because the ground is closer to the viewer 
-- it is supposed to move faster then the background. Like the example
-- with the moving car the fence and he mountains far behind. So 
-- the GROUND_SCROLL_SPEED is set hihger than the 
-- BACKGROUND_SCROLL_SPEED (60 > 30)
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
-- So the we not "run out" of image as we play
local BACKGROUND_LOOPING_POINT = 413

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    -- dt so that we are frame rate independent
    -- if we do not do the modulo background looping point we 
    -- end up running out of image as stated above
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
       % BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH
end

function love.draw()
    push:start()
    
    -- here, we draw our images shifted to the left by their looping point; eventually,
    -- they will revert back to 0 once a certain distance has elapsed, which will make it
    -- seem as if they are infinitely scrolling. choosing a looping point that is seamless
    -- is key, so as to provide the illusion of looping

    -- draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw the ground on top of the background, toward the bottom of the screen,
    -- at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end
