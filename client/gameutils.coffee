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

CanvasExtensions =
  fillCircle: (x, y, radius) ->
    @beginPath()
    @arc(x, y, radius, 0, Math.PI * 2, true)
    @closePath()
    @fill()

  strokeLine: (x1, y1, x2, y2) ->
    @beginPath()
    @moveTo(x1, y1)
    @lineTo(x2, y2)
    @stroke()

GameUtils =
  currentTime: -> (new Date()).getTime()

  extended2DContext: (canvas) ->
    ctx = canvas.getContext("2d")
    $.extend(ctx, CanvasExtensions)
    ctx

  randomId: ->
    chars = "0123456789zxcvbnmasdfghjklqwertyuiop"
    output = ""

    output += chars.charAt(Math.floor(Math.random() * chars.length)) while output.length < 12
    output

window.GameUtils = GameUtils
