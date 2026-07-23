Object           = require 'lib.classic'
local Player     = require 'src.player'
local characters = require 'src.characterRegistery'

function love.load()
  link = Player(200, 200, characters.link)
end

function love.update(dt)
  link:update(dt)
end

function love.draw()
  link:draw()
end
