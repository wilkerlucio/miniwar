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
    @live    = false
    @x       = 50
    @y       = 50
    @dx      = Math.cos(0)
    @dy      = Math.sin(0)
    @bullets = []
    @team    = null

  draw: (ctx, elapsed) ->
    return unless @live
    # setup drawing
    color = if @team then MiniWar["PLAYER_#{@team.toUpperCase()}_COLOR"] else MiniWar.PLAYER_COLOR
    ctx.strokeStyle = color
    ctx.fillStyle   = color
    ctx.lineWidth   = MiniWar.PLAYER_CANNON_HEIGHT

    # draw player circle
    ctx.fillCircle(@x, @y, MiniWar.PLAYER_RADIUS)

    # draw canon
    ctx.strokeLine(@x, @y, @x + @dx * MiniWar.PLAYER_CANNON_RADIUS, @y + @dy * MiniWar.PLAYER_CANNON_RADIUS)

    # draw bullets
    @drawBullets(ctx, elapsed)

  drawBullets: (ctx, elapsed) ->
    Bullet.prototype.doDraw.call(bullet, ctx) for bullet in @bullets

  update: (data) ->
    @x       = data.x
    @y       = data.y
    @dx      = data.dx
    @dy      = data.dy
    @bullets = data.bullets
    @team    = data.team

window.Player = Player
