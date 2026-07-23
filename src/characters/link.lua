return {
  name          = 'Link',
  width         = 42,
  height        = 96,
  spriteOffsetX = -44,
  spriteOffsetY = -5,
  scaleX        = 2,
  scaleY        = 2,
  runSpeed      = 350,
  sprintSpeed   = 650,
  jumpForce     = -900,
  jumpCut       = 0.4,
  coyoteTime    = 0.1,
  jumpBuffer    = 0.1,
  anims         = {
    idle = {
      file        = 'sprites/link/idle.png',
      frameWidth  = 64,
      frameHeight = 52,
      totalFrames = 6,
      interval    = 0.3,
      loop        = true
    },
    run = {
      file        = 'sprites/link/run.png',
      frameWidth  = 64,
      frameHeight = 52,
      totalFrames = 8,
      interval    = 0.2,
      loop        = true
    }
  }
}
