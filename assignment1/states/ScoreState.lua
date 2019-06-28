--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

local image1 = love.graphics.newImage('bronze.jpg')
local image2 = love.graphics.newImage('silver.jpg')
local image3 = love.graphics.newImage('gold.jpg')
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)

    -- Could I do seperate function to choose which function and seperate 
    -- to draw the images????
    -- decide rebon
    
    local scale = 50
    if self.score <= 1 then
      -- 0.05 is the scale
      love.graphics.draw(image1, VIRTUAL_WIDTH/2 - image1:getWidth()*(scale*0.5)/image1:getHeight(), VIRTUAL_HEIGHT/2 + 35 , 0, scale/image1:getWidth(), scale/image1:getHeight(), 0, 0)
    elseif self.score <= 3 then
      -- 1/26 is the scale
      -- in order to get the image where I wanted 
      -- maybe could change the offset??
      love.graphics.draw(image2, VIRTUAL_WIDTH/2 - image2:getWidth()*(scale*0.5)/image2:getHeight(), VIRTUAL_HEIGHT/2 + 35 , 0, scale/image2:getWidth(), scale/image2:getHeight(), 0, 0)
    else
     -- 1/16.4 is the x scale
     -- 1/21.2 is the y scale
     love.graphics.draw(image3, VIRTUAL_WIDTH/2 - image3:getWidth()*(scale*0.5)/image3:getHeight(), VIRTUAL_HEIGHT/2 + 35 , 0, scale/image3:getWidth(), scale/image3:getHeight(), 0, 0)
    end




    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    
    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end


-- Could not see self.score for some reason from this function

--function ScoreState:decideScore()
--
--  print ('Score is', self.score)
--
----    if self.score <= 1 then
----      return 3;
----    elseif self.score <= 3 then
----      return 2;
----    else 
----      return 1;
----    end
--
--end





