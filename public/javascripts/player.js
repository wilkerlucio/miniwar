(function() {
  var Player;
  Player = (function() {
    function Player(game) {
      this.game = game;
      this.live = false;
      this.x = 50;
      this.y = 50;
      this.dx = Math.cos(0);
      this.dy = Math.sin(0);
      this.bullets = [];
      this.team = null;
    }
    Player.prototype.draw = function(ctx, elapsed) {
      var color;
      if (!this.live) {
        return;
      }
      color = this.team ? MiniWar["PLAYER_" + (this.team.toUpperCase()) + "_COLOR"] : MiniWar.PLAYER_COLOR;
      ctx.strokeStyle = color;
      ctx.fillStyle = color;
      ctx.lineWidth = MiniWar.PLAYER_CANNON_HEIGHT;
      ctx.fillCircle(this.x, this.y, MiniWar.PLAYER_RADIUS);
      ctx.strokeLine(this.x, this.y, this.x + this.dx * MiniWar.PLAYER_CANNON_RADIUS, this.y + this.dy * MiniWar.PLAYER_CANNON_RADIUS);
      return this.drawBullets(ctx, elapsed);
    };
    Player.prototype.drawBullets = function(ctx, elapsed) {
      var bullet, _i, _len, _ref, _results;
      _ref = this.bullets;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bullet = _ref[_i];
        _results.push(Bullet.prototype.doDraw.call(bullet, ctx));
      }
      return _results;
    };
    Player.prototype.update = function(data) {
      this.x = data.x;
      this.y = data.y;
      this.dx = data.dx;
      this.dy = data.dy;
      this.bullets = data.bullets;
      return this.team = data.team;
    };
    return Player;
  })();
  window.Player = Player;
}).call(this);
