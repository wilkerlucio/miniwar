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

pr = MiniWar.PLAYER_RADIUS

class PlayablePlayer extends Player
  @MOVE =
    'l':
      axis: 'x'
      dir: -1
      point: -> [@x - pr, @y]
    'r':
      axis: 'x'
      dir: 1
      point: -> [@x + pr, @y]
    'u':
      axis: 'y'
      dir: -1
      point: -> [@x, @y - pr]
    'd':
      axis: 'y'
      dir: 1
      point: -> [@x, @y + pr]

  constructor: (game) ->
    super

    @id = GameUtils.randomId()

  draw: (ctx, elapsed) ->
    @move(elapsed)

    super

    # draw inner circle
    ctx.fillStyle = '#000'
    ctx.fillCircle(@x, @y, MiniWar.PLAYER_RADIUS_SELF)

    @game.connection.send("player_updated", @serialize())

  move: (elapsed) ->
    speed = MiniWar.PLAYER_SPEED * elapsed

    @doMove('l', speed) if KeyboardUtils.keyIsDown(KeyboardUtils.KEY_A)
    @doMove('r', speed) if KeyboardUtils.keyIsDown(KeyboardUtils.KEY_D)
    @doMove('u', speed) if KeyboardUtils.keyIsDown(KeyboardUtils.KEY_W)
    @doMove('d', speed) if KeyboardUtils.keyIsDown(KeyboardUtils.KEY_S)

    @updateAngle(@game.cursor.x, @game.cursor.y)

  doMove: (direction, speed) ->
    r = MiniWar.PLAYER_RADIUS
    dir = PlayablePlayer.MOVE[direction]

    this[dir.axis] += speed * dir.dir

    @x = r if @x < r
    @y = r if @y < r
    @x = MiniWar.MAP_SIZE - r if @x + r > MiniWar.MAP_SIZE
    @y = MiniWar.MAP_SIZE - r if @y + r >= MiniWar.MAP_SIZE

    point = dir.point.call(this)

    while @game.map.isCollidingPoint(point)
      this[dir.axis] = Math.round(this[dir.axis] - 1 * dir.dir)
      point = dir.point.call(this)

  updateAngle: (mx, my) ->
    angle = Math.atan2(my - @y, mx - @x)
    @dx = Math.cos(angle)
    @dy = Math.sin(angle)

  shot: ->
    @bullets.push(new Bullet(@game, @x, @y, @dx, @dy)) unless @bullets.length == MiniWar.BULLET_MAX

  serialize: ->
    {id: @id, x: @x, y: @y, dx: @dx, dy: @dy}

window.PlayablePlayer = PlayablePlayer
