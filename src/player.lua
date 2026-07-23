local Entity = require 'src.entity'
local Player = Entity:extend()

local DOUBLE_TAP_WINDOW = 0.25

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
  self.state           = 'idle'
  self.isLocked        = false
  self.isSprinting     = false
  self.lastTapTime     = { a = -math.huge, d = -math.huge }
  self.lastTapKey      = nil
  self.coyoteTimer     = 0
  self.jumpBufferTimer = 0
end

function Player:keypressed(key)
  if key == 'space' then
    self.jumpBufferTimer = self.data.jumpBuffer
    self:jump()
  end

  if key ~= 'a' and key ~= 'd' then return end

  local now     = love.timer.getTime()
  local elapsed = now - self.lastTapTime[key]

  if elapsed <= DOUBLE_TAP_WINDOW then
    self.isSprinting = true
    self.lastTapKey = key
  end

  self.lastTapTime[key] = now
end

function Player:keyreleased(key)
  if key == 'space' and self.vy < 0 then
    self.vy = self.vy * self.data.jumpCut
  end
end

function Player:jump()
  if self.coyoteTimer > 0 and not self.isLocked then
    self.vy              = self.data.jumpForce
    self.coyoteTimer     = 0
    self.jumpBufferTimer = 0
    self.isGrounded      = false
  end
end

function Player:update(dt, stage)
  local dir = self.isFacingRight and 1 or -1
  local movingLeft = love.keyboard.isDown('a')
  local movingRight = love.keyboard.isDown('d')

  if movingLeft then
    self.isFacingRight = false
  elseif movingRight then
    self.isFacingRight = true
  end

  if self.isSprinting then
    if self.lastTapKey == 'a' and not movingLeft then
      self.isSprinting = false
    elseif self.lastTapKey == 'd' and not movingRight then
      self.isSprinting = false
    elseif (self.lastTapKey == 'a' and movingRight) or (self.lastTapKey == 'd' and movingLeft) then
      self.isSprinting = false
    end
  end

  if not self.isLocked then
    if movingLeft or movingRight then
      local speed = self.isSprinting and self.data.sprintSpeed or self.data.runSpeed
      self.x = self.x + speed * dir * dt
    end
  end

  -- coyoteTimer countdown --
  if self.isGrounded then
    self.coyoteTimer = self.data.coyoteTime
  else
    self.coyoteTimer = self.coyoteTimer - dt
  end

  -- jumpBuffer countdown --
  if self.isGrounded and self.jumpBufferTimer > 0 then
    self:jump()
    self.jumpBufferTimer = 0
  end

  -- physics + collision via entity --
  self:updatePhysics(dt, stage)

  -- animation --
  self:updateAnimation(dt)

  -- state machine --
  if self.isLocked then
    -- do nothing --
  elseif not self.isGrounded and self.vy < 0 then
    self:setState('jump')
  elseif not self.isGrounded and self.vy >= 0 then
    self:setState('fall')
  elseif (movingLeft or movingRight) and self.isSprinting then
    self:setState('sprint')
  elseif (movingLeft or movingRight) and not self.isSprinting then
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
