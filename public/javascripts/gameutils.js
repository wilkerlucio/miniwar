(function() {
  var CanvasExtensions, GameUtils;
  CanvasExtensions = {
    fillCircle: function(x, y, radius) {
      this.beginPath();
      this.arc(x, y, radius, 0, Math.PI * 2, true);
      this.closePath();
      return this.fill();
    },
    strokeLine: function(x1, y1, x2, y2) {
      this.beginPath();
      this.moveTo(x1, y1);
      this.lineTo(x2, y2);
      return this.stroke();
    }
  };
  GameUtils = {
    currentTime: function() {
      return (new Date()).getTime();
    },
    extended2DContext: function(canvas) {
      var ctx;
      ctx = canvas.getContext("2d");
      $.extend(ctx, CanvasExtensions);
      return ctx;
    },
    randomId: function() {
      var chars, output;
      chars = "0123456789zxcvbnmasdfghjklqwertyuiop";
      output = "";
      while (output.length < 12) {
        output += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      return output;
    }
  };
  window.GameUtils = GameUtils;
}).call(this);
