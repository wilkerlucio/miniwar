(function() {
  var Bullet;
  Bullet = (function() {
    function Bullet(game, x, y, dx, dy) {
      this.game = game;
      this.dx = dx;
      this.dy = dy;
      this.x = x + this.dx * MiniWar.PLAYER_CANNON_RADIUS;
      this.y = y + this.dy * MiniWar.PLAYER_CANNON_RADIUS;
    }
    Bullet.prototype.draw = function(ctx, elapsed) {
      this.x += this.dx * MiniWar.BULLET_SPEED * elapsed;
      this.y += this.dy * MiniWar.BULLET_SPEED * elapsed;
      return this.doDraw(ctx);
    };
    Bullet.prototype.doDraw = function(ctx) {
      ctx.fillStyle = MiniWar.BULLET_COLOR;
      ctx.beginPath();
      ctx.arc(this.x, this.y, MiniWar.BULLET_RADIUS, 0, Math.PI * 2, true);
      ctx.closePath();
      return ctx.fill();
    };
    Bullet.prototype.isAlive = function() {
      var r, s;
      r = MiniWar.BULLET_RADIUS;
      s = MiniWar.MAP_SIZE;
      if (this.x < 0) {
        return false;
      }
      if (this.x > s) {
        return false;
      }
      if (this.y < 0) {
        return false;
      }
      if (this.y > s) {
        return false;
      }
      if (this.game.map.isCollidingPoint([this.x, this.y])) {
        return false;
      }
      if (this.game.map.isCollidingPoint([this.x, this.y - r])) {
        return false;
      }
      if (this.game.map.isCollidingPoint([this.x + r, this.y])) {
        return false;
      }
      if (this.game.map.isCollidingPoint([this.x, this.y + r])) {
        return false;
      }
      if (this.game.map.isCollidingPoint([this.x - r, this.y])) {
        return false;
      }
      return true;
    };
    return Bullet;
  })();
  window.Bullet = Bullet;
}).call(this);
