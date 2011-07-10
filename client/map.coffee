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

class Map
  constructor: (@mapData) ->
    @draws = []
    @map = []

    @init()

  draw: (ctx) ->
    ctx.drawImage(@drawCache, 0, 0)

  isCollidingPoint: (point) ->
    return false if point[1] < 0 or point[0] < 0

    x = Math.round(point[0])
    y = Math.round(point[1])

    row = @map[y]
    return false unless row

    return row[x]

  init: ->
    bs = 10 # block size

    tempCanvas            = document.createElement("canvas")
    tempCanvas.width      = MiniWar.MAP_SIZE
    tempCanvas.height     = MiniWar.MAP_SIZE

    tempContext           = tempCanvas.getContext("2d")
    tempContext.fillStyle = MiniWar.BRICK_COLOR

    for row, y in @mapData
      mapRow = []

      for col, x in row.split('')
        i = bs

        if col == '#'
          mapRow.push(true) while i-- > 0
          tempContext.fillRect(x * bs, y * bs, bs, bs)
        else
          mapRow.push(false) while i-- > 0

      i = bs
      @map.push(mapRow) while i-- > 0

    @drawCache = tempCanvas

window.Map = Map
