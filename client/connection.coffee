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

host = location.href.match(/:\/\/([^:\/]+)/)[1]

class Connection
  constructor: (@id, @onconnect) ->
    @socket = new WebSocket("ws://#{host}:8080")
    @socket.onmessage = (message) => @dispatch(JSON.parse(message.data))
    @binds = []
    @connected = false

  bind: (callback) -> @binds.push(callback)
  dispatch: (data) ->
    if data.type == "id_request"
      console.log("sending id")
      @send('user_id', @id)
    else if data.type == "connection_ok"
      @connected = true
      @onconnect()
      console.log("connection ok")
    else
      bind(data) for bind in @binds

  send: (type, data) ->
    return false unless @connected or type == "user_id"
    message = {type: type, data: data}
    message = JSON.stringify(message)

    @socket.send(message)

window.Connection = Connection
