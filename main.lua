Object           = require 'lib.classic'
local Player     = require 'src.player'
local Stage      = require 'src.stage'
local characters = require 'src.characterRegistery'

function love.load()
  stage = Stage()
  link = Player(200, 200, characters.link)
end

function love.keypressed(key)
  link:keypressed(key)
end

function love.keyreleased(key)
  link:keyreleased(key)
end

function love.update(dt)
  link:update(dt, stage)
end

function love.draw()
  stage:draw()
  link:draw()
end
