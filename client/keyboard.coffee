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

# private stuff
pressedKeys  = {}
reactKeyDown = (e) -> pressedKeys[e.keyCode] = true
reactKeyUp   = (e) -> pressedKeys[e.keyCode] = false

# public stuff
Keyboard =
  # common key codes
  KEY_LEFT:   37
  KEY_UP:     38
  KEY_RIGHT:  39
  KEY_DOWN:   40
  KEY_RETURN: 13
  KEY_ESPACE: 32
  KEY_SHIFT:  16
  KEY_CTRL:   17
  KEY_ALT:    18
  KEY_TAB:    9

  keyIsDown: (code) -> pressedKeys[code] == true

# register chars key codes
defineKeyCodeRange = (chars, code, prefix = '') -> Keyboard["KEY_" + prefix + chr] = code++ for chr in chars.split('')

defineKeyCodeRange("ABCDEFGHIJKLMNOPQRSTUVWXYZ", 65) # letters
defineKeyCodeRange("0123456789", 48) # numbers
defineKeyCodeRange("0123456789", 96, "NUM_") # numpad numbers

# register event reactor
$ ->
  $(document.body).keydown (e) -> reactKeyDown(e)
  $(document.body).keyup (e) -> reactKeyUp(e)

window.KeyboardUtils = Keyboard
