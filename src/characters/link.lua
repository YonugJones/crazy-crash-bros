-- self.data --
return {
  name          = 'Link',
  width         = 42,
  height        = 96,
  spriteOffsetX = -44,
  spriteOffsetY = -5,
  scaleX        = 2,
  scaleY        = 2,
  runSpeed      = 350,
  sprintSpeed   = 600,
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
      interval    = 0.1,
      loop        = true
    },
    sprint = {
      file         = 'sprites/link/sprint.png',
      frameWidth   = 64,
      frameHeight  = 64,
      totalFrames  = 8,
      sheetOffsetY = 12,
      interval     = 0.09,
      loop         = true
    },
    jump = {
      file        = 'sprites/link/jump.png',
      frameWidth  = 0,
      frameHeight = 0,
      totalFrames = 2,
      interval    = 0.04,
      loop        = true
    },
    fall = {
      file        = 'sprites/link/fall.png',
      frameWidth  = 0,
      frameHeight = 0,
      totalFrames = 2,
      interval    = 0.04,
      loop        = true
    },
  }
}
