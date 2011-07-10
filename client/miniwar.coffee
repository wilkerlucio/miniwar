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

class MiniWar
  @MAP_SIZE             = 600
  @BACKGROUND_COLOR     = "#7cce66"
  @BRICK_COLOR          = "#908e8c"
  @PLAYER_COLOR         = "#886f31"
  @PLAYER_RADIUS        = 6
  @PLAYER_RADIUS_SELF   = 3
  @PLAYER_CANNON_RADIUS = 10
  @PLAYER_CANNON_HEIGHT = 4
  @PLAYER_SPEED         = 0.1
  @BULLET_COLOR         = "#000000"
  @BULLET_SPEED         = 0.4
  @BULLET_RADIUS        = 2
  @BULLET_MAX           = 3
  @CURSOR_SIZE          = 3

  constructor: (@canvas) ->
    @canvas.style.cursor = "none" # hide original cursor

    @width      = canvas.width
    @height     = canvas.height
    @ctx        = GameUtils.extended2DContext(@canvas)
    @player     = new PlayablePlayer(this)
    @connection = new Connection(@player.id)

    @connection.bind (message) => @handleMessage(message.type, message.data)

    @newGame()
    @startGameLoop()

  startGameLoop: ->
    @lastTime = Date.currentTime()
    @timer = setInterval((=> @gameLoop()), 20)

  newGame: ->
    @cursor  = new Cursor()
    @players = []
    @map     = new Map(Maps[0])
    @counter = new FpsCounter()

    $(@canvas).mousemove (e) =>
      @cursor.updatePosition(e.clientX, e.clientY)

    $(@canvas).mousedown (e) =>
      @player.shot()

  gameLoop: ->
    currentTime = Date.currentTime()
    distance    = currentTime - @lastTime

    @ctx.fillStyle = MiniWar.BACKGROUND_COLOR
    @ctx.fillRect(0, 0, @width, @height)

    @player.draw(@ctx, distance)
    player.draw(@ctx, distance) for player in @players
    @map.draw(@ctx)
    @cursor.draw(@ctx)
    @counter.draw(@ctx, distance)

    @lastTime = currentTime

  findOrCreatePlayer: (id) ->
    for player in @players
      return player if player.id == id

    player = new Player(this)
    player.id = id
    @players.push(player)
    player

  handleMessage: (type, data) ->
    if type == "player_updated"
      player = @findOrCreatePlayer(data.id)
      player.update(data)

window.MiniWar = MiniWar
