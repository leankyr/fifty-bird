--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    -- randomize the gap between the pipes
    -- the pipes here spawn every two seconds
    -- what we want to do is make them spawn between 1.5 second and 2.5
    -- math.random generates a real number between 0 and 1
    -- so in the way bellow we get the effect we want
    self.spawnInterval = 1.5 + math.random()
    -- print for debugging purposes
    print('spawnInterval is:', self.spawnInterval)
    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- Transition to Pause State
    if love.keyboard.wasPressed('p') then
      gStateMachine:change('pause', {
        score = self.score,
        timer = self.timer,
        bird = self.bird,
        pipePairs = self.pipePairs,
        spawnInterval = self.spawnInterval,
        lastY = self.lastY
      })
    end
    
    -- update timer for pipe spawning
    self.timer = self.timer + dt
    -- spawn a new pipe pair every second and a half
        -- spawnInterval = 1.5 + math.random() 
    -- print('spawnInterval is:', spawnInterval)
    if self.timer > self.spawnInterval then
      -- rerandomize the interval
      -- Should I pass the interval as an argument to the update dt function???
      -- is it better design approach???
      -- but how ??
      -- Should I use randomseed instead??
      self.spawnInterval = 1.5 + math.random()
      -- print for debugging purposes
      print('spawnInterval is:', self.spawnInterval)

        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        -- we randomize the gap height here
        -- So now as you play the gap between the pipes will randomly
        -- change between 80 and 100 pixels.
        -- In case we wanted every round the gap to be different
        -- we could change the hardcoded GAP_HEIGHT value to different number (eg GAP_HEIGHT = 100)
        local gap_height = math.random(80, 100)
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - gap_height - PIPE_HEIGHT))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y, gap_height))

        -- reset timer
        self.timer = 0
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    love.graphics.setFont(mediumFont)
    love.graphics.print('Press \'p\' to Pause the game', 8, 32)

    self.bird:render()
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter(params)
    -- if we're coming from death, restart scrolling
    scrolling = true
    if params ~= nil then
      self.score = params.score
      self.timer = params.timer
      self.bird = params.bird
      self.pipePairs = params.pipePairs
      self.spawnInterval = params.spawnInterval
      self.lastY = params.lastY
    end
    --self.score = params.score
    --self.timer = params.timer
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
