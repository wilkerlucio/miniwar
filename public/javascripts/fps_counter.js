(function() {
  var FpsCounter;
  FpsCounter = (function() {
    FpsCounter.LATEST_SIZE = 10;
    function FpsCounter() {
      this.latest = [];
    }
    FpsCounter.prototype.draw = function(ctx, elapsed) {
      var fps;
      this.latest.push(1000 / elapsed);
      fps = this.countFps();
      ctx.fillStyle = '#000';
      return ctx.fillText("" + fps + "fps", 3, 10);
    };
    FpsCounter.prototype.countFps = function() {
      var fps, sum, _i, _len, _ref;
      while (this.latest.length > FpsCounter.LATEST_SIZE) {
        this.latest.shift();
      }
      sum = 0;
      _ref = this.latest;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fps = _ref[_i];
        sum += fps;
      }
      return Math.round(sum / this.latest.length);
    };
    return FpsCounter;
  })();
  window.FpsCounter = FpsCounter;
}).call(this);
