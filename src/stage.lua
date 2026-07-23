local Stage = Object:extend()

function Stage:new()
  -- each platform is a rectangle --
  self.platforms = {
    { x = 50, y = 500, width = 1180, height = 100 } -- main ground
    -- add floating platforms later, e.g.:
    -- { x = 300, y = 350, width = 200, height = 20 },
  }
end

function Stage:draw()
  love.graphics.setColor(0.3, 0.7, 0.3)
  for _, p in ipairs(self.platforms) do
    love.graphics.rectangle('fill', p.x, p.y, p.width, p.height)
  end
  love.graphics.setColor(1, 1, 1)
end

return Stage
