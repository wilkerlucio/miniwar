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

class Bullet
  constructor: (@game, x, y, @dx, @dy) ->
    @x = x + @dx * MiniWar.PLAYER_CANNON_RADIUS
    @y = y + @dy * MiniWar.PLAYER_CANNON_RADIUS

  draw: (ctx, elapsed) ->
    @x += @dx * MiniWar.BULLET_SPEED * elapsed
    @y += @dy * MiniWar.BULLET_SPEED * elapsed

    ctx.fillStyle = MiniWar.BULLET_COLOR

    ctx.beginPath()
    ctx.arc(@x, @y, MiniWar.BULLET_RADIUS, 0, Math.PI * 2, true)
    ctx.closePath()
    ctx.fill()

  isAlive: ->
    r = MiniWar.BULLET_RADIUS
    s = MiniWar.MAP_SIZE

    return false if @x < 0
    return false if @x > s
    return false if @y < 0
    return false if @y > s
    return false if @game.map.isCollidingPoint([@x, @y])
    return false if @game.map.isCollidingPoint([@x, @y - r])
    return false if @game.map.isCollidingPoint([@x + r, @y])
    return false if @game.map.isCollidingPoint([@x, @y + r])
    return false if @game.map.isCollidingPoint([@x - r, @y])

    true

window.Bullet = Bullet
