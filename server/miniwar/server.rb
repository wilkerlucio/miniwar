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
    MIN_PLAYERS = 2

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
      @state = :waiting
    end

    def connection_opened(socket)
      @clientSockets << socket
      socket.send({:type => "id_request", :data => nil}.to_json)
    end

    def connection_message(socket, message_string)
      message = JSON.parse(message_string)

      if @clients[socket]
        if message["type"] == "player_died"
          respond_message_player_died(message["data"], message_string, socket)
        else
          broadcast(message_string, socket)
        end
      else
        if message["type"] == "user_id"
          @clients[socket] = Player.new(socket, message["data"])
          puts "Connected player id #{message["data"]}"
          socket.send({:type => "connection_ok", :data => nil}.to_json)
          start_game
        else # not an registered user, ask for registration again
          socket.send({:type => "id_request", :data => nil}.to_json)
        end
      end
    end

    def connection_closed(socket)
      if client = @clients[socket]
        broadcast({:type => "player_quit", :data => client.id}.to_json, socket)
        puts "Player #{client.id} quit."
        @clients.delete(socket)
        check_game_status
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

    def respond_message_player_died(id, message, socket)
      puts "killed player #{id}"

      @clients.each_pair do |socket, player|
        if player.id == id
          puts "real killed player #{id}"
          player.live = false
        end
      end

      broadcast(message, socket)

      check_game_status
    end

    def start_game
      return if @clients.length < MIN_PLAYERS
      return if @state == :running

      @state = :running

      assign_teams

      @clients.each_pair do |socket, client|
        client.live = true
        client.send_message("start_game")
      end

      puts "New round started"
    end

    def check_game_status
      reds = 0
      blues = 0

      @clients.each_pair do |socket, client|
        if client.live
          reds += 1 if client.team == :red
          blues += 1 if client.team == :blue
        end
      end

      puts "reds: #{reds}, blues: #{blues}"

      if reds == 0 or blues == 0
        puts "Round finished, starting new one"
        @state = :waiting
        start_game
      end
    end

    def assign_teams
      team = :red

      @clients.each_pair do |socket, client|
        client.team = team
        client.send_message("assign_team", team)
        team = team == :red ? :blue : :red
      end
    end
  end
end
