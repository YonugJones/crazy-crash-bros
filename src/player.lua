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
  self.state = 'idle'
end

function Player:update(dt)
  self:updatePhysics(dt)
  self:updateAnimation(dt)
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
