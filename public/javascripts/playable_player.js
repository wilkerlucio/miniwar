(function() {
  var PlayablePlayer, pr;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  pr = MiniWar.PLAYER_RADIUS;
  PlayablePlayer = (function() {
    __extends(PlayablePlayer, Player);
    PlayablePlayer.MOVE = {
      'l': {
        axis: 'x',
        dir: -1,
        point: function() {
          return [this.x - pr, this.y];
        }
      },
      'r': {
        axis: 'x',
        dir: 1,
        point: function() {
          return [this.x + pr, this.y];
        }
      },
      'u': {
        axis: 'y',
        dir: -1,
        point: function() {
          return [this.x, this.y - pr];
        }
      },
      'd': {
        axis: 'y',
        dir: 1,
        point: function() {
          return [this.x, this.y + pr];
        }
      }
    };
    function PlayablePlayer(game) {
      PlayablePlayer.__super__.constructor.apply(this, arguments);
      this.id = GameUtils.randomId();
    }
    PlayablePlayer.prototype.draw = function(ctx, elapsed) {
      this.move(elapsed);
      PlayablePlayer.__super__.draw.apply(this, arguments);
      ctx.fillStyle = '#000';
      ctx.fillCircle(this.x, this.y, MiniWar.PLAYER_RADIUS_SELF);
      return this.game.connection.send("player_updated", this.serialize());
    };
    PlayablePlayer.prototype.move = function(elapsed) {
      var speed;
      speed = MiniWar.PLAYER_SPEED * elapsed;
      if (KeyboardUtils.keyIsDown(KeyboardUtils.KEY_A)) {
        this.doMove('l', speed);
      }
      if (KeyboardUtils.keyIsDown(KeyboardUtils.KEY_D)) {
        this.doMove('r', speed);
      }
      if (KeyboardUtils.keyIsDown(KeyboardUtils.KEY_W)) {
        this.doMove('u', speed);
      }
      if (KeyboardUtils.keyIsDown(KeyboardUtils.KEY_S)) {
        this.doMove('d', speed);
      }
      return this.updateAngle(this.game.cursor.x, this.game.cursor.y);
    };
    PlayablePlayer.prototype.doMove = function(direction, speed) {
      var dir, point, r, _results;
      r = MiniWar.PLAYER_RADIUS;
      dir = PlayablePlayer.MOVE[direction];
      this[dir.axis] += speed * dir.dir;
      if (this.x < r) {
        this.x = r;
      }
      if (this.y < r) {
        this.y = r;
      }
      if (this.x + r > MiniWar.MAP_SIZE) {
        this.x = MiniWar.MAP_SIZE - r;
      }
      if (this.y + r >= MiniWar.MAP_SIZE) {
        this.y = MiniWar.MAP_SIZE - r;
      }
      point = dir.point.call(this);
      _results = [];
      while (this.game.map.isCollidingPoint(point)) {
        this[dir.axis] = Math.round(this[dir.axis] - 1 * dir.dir);
        _results.push(point = dir.point.call(this));
      }
      return _results;
    };
    PlayablePlayer.prototype.updateAngle = function(mx, my) {
      var angle;
      angle = Math.atan2(my - this.y, mx - this.x);
      this.dx = Math.cos(angle);
      return this.dy = Math.sin(angle);
    };
    PlayablePlayer.prototype.shot = function() {
      if (this.bullets.length !== MiniWar.BULLET_MAX) {
        return this.bullets.push(new Bullet(this.game, this.x, this.y, this.dx, this.dy));
      }
    };
    PlayablePlayer.prototype.serialize = function() {
      return {
        id: this.id,
        x: this.x,
        y: this.y,
        dx: this.dx,
        dy: this.dy
      };
    };
    return PlayablePlayer;
  })();
  window.PlayablePlayer = PlayablePlayer;
}).call(this);
