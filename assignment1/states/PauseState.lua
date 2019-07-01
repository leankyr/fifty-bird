-- Implementing Pause Class
PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
  self.score = params.score
  self.timer = params.timer
  self.bird = params.bird
  self.pipePairs = params.pipePairs
  self.spawnInterval = params.spawnInterval
  self.lastY = params.lastY
end

function PauseState:update(dt)
  if love.keyboard.wasPressed('p') then
    gStateMachine:change('play', {
      score = self.score,
      timer = self.timer,
      bird = self.bird,
      pipePairs = self.pipePairs,
      spawnInterval = self.spawnInterval,
      lastY = self.lastY  
    })
  
  end

end

function PauseState:render()

  -- to render the bird
  self.bird:render() 
  -- to render the pipes
  for k, pair in pairs(self.pipePairs) do
    pair:render()
  end
  
  -- to print messeages
  love.graphics.printf('GAME IS PAUSED\nPRESS p TO RESUME', 0, 70, VIRTUAL_WIDTH, 'center')

  love.graphics.printf('Score: ' ..tostring(self.score), 0, 130, VIRTUAL_WIDTH, 'center')

end 

