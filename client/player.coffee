# Copyright (c) 2011 Wilker Lúcio
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

class Player
  constructor: (@game) ->
    @x       = 50
    @y       = 50
    @dx      = Math.cos(0)
    @dy      = Math.sin(0)
    @bullets = []

  draw: (ctx, elapsed) ->
    # setup drawing
    ctx.strokeStyle = MiniWar.PLAYER_COLOR
    ctx.fillStyle   = MiniWar.PLAYER_COLOR
    ctx.lineWidth   = MiniWar.PLAYER_CANNON_HEIGHT

    # draw player circle
    ctx.fillCircle(@x, @y, MiniWar.PLAYER_RADIUS)

    # draw canon
    ctx.strokeLine(@x, @y, @x + @dx * MiniWar.PLAYER_CANNON_RADIUS, @y + @dy * MiniWar.PLAYER_CANNON_RADIUS)

    # draw bullets
    bullet.draw(ctx, elapsed) for bullet in @bullets
    @bullets = @bullets.filter (bullet) -> bullet.isAlive()

  update: (data) ->
    @x  = data.x
    @y  = data.y
    @dx = data.dx
    @dy = data.dy

window.Player = Player
