(function() {
  var Cursor;
  Cursor = (function() {
    function Cursor() {
      this.x = 0;
      this.y = 0;
    }
    Cursor.prototype.draw = function(ctx) {
      var cs;
      cs = MiniWar.CURSOR_SIZE;
      ctx.strokeStyle = '#000';
      ctx.lineWidth = 2;
      ctx.strokeLine(this.x - cs, this.y, this.x + cs, this.y);
      return ctx.strokeLine(this.x, this.y - cs, this.x, this.y + cs);
    };
    Cursor.prototype.updatePosition = function(x, y) {
      this.x = x;
      this.y = y;
    };
    return Cursor;
  })();
  window.Cursor = Cursor;
}).call(this);
