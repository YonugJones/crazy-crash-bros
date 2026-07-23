local Entity = Object:extend()

local GRAVITY = 1800 -- add gravity aftwer tile collision

function Entity:new(x, y, width, height, anims)
  -- position --
  self.x             = x
  self.y             = y
  self.prevY         = y
  self.width         = width
  self.height        = height
  self.isFacingRight = true

  -- vertical --
  self.vy            = 0
  self.isGrounded    = false

  -- animation --
  self.anims         = anims
  self.sheets        = {}
  self.quads         = {}
  self.state         = nil
  self.currentFrame  = 1
  self.frameTimer    = 0
  self.frameInterval = nil

  -- load spritesheets + build quads --
  for name, def in pairs(anims) do
    if not self.sheets[def.file] then
      self.sheets[def.file] = love.graphics.newImage(def.file)
    end

    self.sheets[name] = self.sheets[def.file]
    self.quads[name] = {}

    local offsetX = def.sheetOffsetX or 0
    local offsetY = def.sheetOffsetY or 0
    for i = 0, def.totalFrames - 1 do
      self.quads[name][i + 1] = love.graphics.newQuad(
        (offsetX + i) * def.frameWidth,   --x
        offsetY,                          --y,
        def.frameWidth,                   --width
        def.frameHeight,                  --height
        self.sheets[name]:getDimensions() --spritesheet width + spritesheet height
      )
    end
  end
end

function Entity:setState(newState)
  if self.state == newState then return end
  self.state         = newState
  self.currentFrame  = 1
  self.frameTimer    = 0
  self.frameInterval = nil
end

function Entity:updatePhysics(dt, stage)
  self.prevY      = self.y
  self.vy         = self.vy + GRAVITY * dt
  self.y          = self.y + self.vy * dt
  self.isGrounded = false

  if stage then
    for _, p in ipairs(stage.platforms) do
      if self:isOverlapping(p) then
        self:resolveCollision(p)
      end
    end
  end
end

function Entity:updateAnimation(dt)
  local def = self.anims[self.state]
  if not def then return end
  local interval = self.frameInterval or def.interval

  -- single frame non-looping: fire onAnimationEnd after one interval --
  if def.totalFrames == 1 and not def.loop then
    self.frameTimer = self.frameTimer + dt
    if self.frameTimer >= interval then
      self.frameTimer = 0
      self:onAnimationEnd()
    end
    return -- exit here, don't fall through
  end

  self.frameTimer = self.frameTimer + dt

  if self.frameTimer >= interval then
    self.frameTimer = self.frameTimer - interval

    if def.loop then
      self.currentFrame = (self.currentFrame % def.totalFrames) + 1
    elseif self.currentFrame < def.totalFrames then
      self.currentFrame = self.currentFrame + 1
    else
      self:onAnimationEnd()
    end
  end
end

function Entity:onAnimationEnd()
  -- let subclass handle this --
end

function Entity:isOverlapping(p)
  return self.x < p.x + p.width
      and self.x + self.width > p.x
      and self.y < p.y + p.height
      and self.y + self.height > p.y
end

function Entity:resolveCollision(p)
  -- only resolve if falling and entity's feet are above platform's top
  local wasAbove = self.prevY + self.height <= p.y

  if self.vy >= 0 and wasAbove then
    self.y          = p.y - self.height
    self.vy         = 0
    self.isGrounded = true
  end
end

function Entity:draw(spriteOffsetX, spriteOffsetY, scaleX, scaleY)
  local def = self.anims[self.state]
  if not def then return end

  scaleX = scaleX or 1
  scaleY = scaleY or 1

  local flipX = self.isFacingRight and 1 or -1
  local offsetX = self.isFacingRight and 0 or def.frameWidth * scaleX

  local animOffsetX = def.offsetX or 0
  local animOffsetY = def.offsetY or 0

  love.graphics.draw(
    self.sheets[self.state],                               -- drawable
    self.quads[self.state][self.currentFrame],             -- quad
    self.x + (spriteOffsetX or 0) + offsetX + animOffsetX, -- x
    self.y + (spriteOffsetY or 0) + animOffsetY,           -- y
    0,                                                     --r
    flipX * scaleX,                                        -- sx
    scaleY                                                 -- sy
  )
end

return Entity
