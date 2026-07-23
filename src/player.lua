local Entity = require 'src.entity'
local Player = Entity:extend()

function Player:new(x, y, characterData)
  self.data = characterData
  Player.super.new(
    self,
    x,
    y,
    characterData.width,
    characterData.height,
    characterData.anims
  )
  self.state    = 'idle'
  self.isLocked = false
end

function Player:update(dt)
  -- horizontal movement --
  local dir = self.isFacingRight and 1 or -1
  if love.keyboard.isDown('a') then
    self.isFacingRight = false
  elseif love.keyboard.isDown('d') then
    self.isFacingRight = true
  end

  if not self.isLocked then
    if love.keyboard.isDown('a') or love.keyboard.isDown('d') then
      self.x = self.x + self.data.runSpeed * dir * dt
    end
  end

  self:updatePhysics(dt)
  self:updateAnimation(dt)

  -- state machine --
  if self.isLocked then
    -- do nothing --
  elseif love.keyboard.isDown('a') or love.keyboard.isDown('d') then
    self:setState('run')
  else
    self:setState('idle')
  end
end

function Player:draw()
  love.graphics.setColor(1, 1, 1)
  Entity.draw(
    self,
    self.data.spriteOffsetX,
    self.data.spriteOffsetY,
    self.data.scaleX,
    self.data.scaleY
  )

  -- debug collision box
  love.graphics.setColor(1, 0, 0, 0.5)
  love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
  love.graphics.setColor(1, 1, 1, 1)
end

return Player
