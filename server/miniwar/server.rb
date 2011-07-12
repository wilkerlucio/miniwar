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

require 'em-websocket'
require 'json'

module MiniWar
  class Server
    def self.start(options)
      server = self.new

      EventMachine::WebSocket.start(options) do |socket|
        socket.onopen { server.connection_opened(socket) }
        socket.onmessage { |message| server.connection_message(socket, message) }
        socket.onclose { server.connection_closed(socket) }
      end
    end

    def initialize
      @clientSockets = []
      @clients = {}
    end

    def connection_opened(socket)
      @clientSockets << socket
      socket.send({:type => "id_request", :data => nil}.to_json)
    end

    def connection_message(socket, message)
      if @clients[socket]
        message = JSON.parse(message)
        responder = "respond_message_#{message["type"]}"

        if respond_to?(responder)
          send(responder, message["data", message])
        else
          broadcast(message, socket)
        end
      else
        message = JSON.parse(message)

        if message["type"] == "user_id"
          @clients[socket] = Player.new(socket, message["data"])
          puts "Connected player id #{message["data"]}"
          socket.send({:type => "connection_ok", :data => nil}.to_json)
        else # not an registered user, ask for registration again
          socket.send({:type => "id_request", :data => nil}.to_json)
        end
      end
    end

    def connection_closed(socket)
      if client = @clients[socket]
        broadcast({:type => "player_quit", :data => client.id}.to_json, socket)
        puts "Player #{client.id} quit."
        @clients[socket] = nil
      end

      @clientSockets.delete(socket)
    end

    def broadcast(message, ignore_socket = nil)
      @clients.each_pair do |socket, player|
        next if socket == ignore_socket

        socket.send message
      end
    end

    private
  end
end
