(function() {
  var MiniWar;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  MiniWar = (function() {
    MiniWar.MAP_SIZE = 600;
    MiniWar.BACKGROUND_COLOR = "#7cce66";
    MiniWar.BRICK_COLOR = "#908e8c";
    MiniWar.PLAYER_COLOR = "#886f31";
    MiniWar.PLAYER_RADIUS = 6;
    MiniWar.PLAYER_RADIUS_SELF = 3;
    MiniWar.PLAYER_CANNON_RADIUS = 10;
    MiniWar.PLAYER_CANNON_HEIGHT = 4;
    MiniWar.PLAYER_SPEED = 0.1;
    MiniWar.BULLET_COLOR = "#000000";
    MiniWar.BULLET_SPEED = 0.4;
    MiniWar.BULLET_RADIUS = 2;
    MiniWar.BULLET_MAX = 3;
    MiniWar.CURSOR_SIZE = 3;
    function MiniWar(canvas) {
      this.canvas = canvas;
      this.canvas.style.cursor = "none";
      this.width = canvas.width;
      this.height = canvas.height;
      this.ctx = GameUtils.extended2DContext(this.canvas);
      this.player = new PlayablePlayer(this);
      this.connection = new Connection();
      this.connection.bind(__bind(function(message) {
        return this.handleMessage(message.type, message.data);
      }, this));
      this.newGame();
      this.startGameLoop();
    }
    MiniWar.prototype.startGameLoop = function() {
      this.lastTime = Date.currentTime();
      return this.timer = setInterval((__bind(function() {
        return this.gameLoop();
      }, this)), 20);
    };
    MiniWar.prototype.newGame = function() {
      this.cursor = new Cursor();
      this.players = [];
      this.map = new Map(Maps[0]);
      this.counter = new FpsCounter();
      $(this.canvas).mousemove(__bind(function(e) {
        return this.cursor.updatePosition(e.clientX, e.clientY);
      }, this));
      return $(this.canvas).mousedown(__bind(function(e) {
        return this.player.shot();
      }, this));
    };
    MiniWar.prototype.gameLoop = function() {
      var currentTime, distance, player, _i, _len, _ref;
      currentTime = Date.currentTime();
      distance = currentTime - this.lastTime;
      this.ctx.fillStyle = MiniWar.BACKGROUND_COLOR;
      this.ctx.fillRect(0, 0, this.width, this.height);
      this.player.draw(this.ctx, distance);
      _ref = this.players;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        player = _ref[_i];
        player.draw(this.ctx, distance);
      }
      this.map.draw(this.ctx);
      this.cursor.draw(this.ctx);
      this.counter.draw(this.ctx, distance);
      return this.lastTime = currentTime;
    };
    MiniWar.prototype.findOrCreatePlayer = function(id) {
      var player, _i, _len, _ref;
      _ref = this.players;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        player = _ref[_i];
        if (player.id === id) {
          return player;
        }
      }
      player = new Player(this);
      player.id = id;
      this.players.push(player);
      return player;
    };
    MiniWar.prototype.handleMessage = function(type, data) {
      var player;
      if (type === "player_updated") {
        player = this.findOrCreatePlayer(data.id);
        return player.update(data);
      }
    };
    return MiniWar;
  })();
  window.MiniWar = MiniWar;
}).call(this);
