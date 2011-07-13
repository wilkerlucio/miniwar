(function() {
  var Map;
  Map = (function() {
    Map.TEAMS = {
      'red': 1,
      'blue': 2
    };
    function Map(mapData) {
      this.mapData = mapData;
      this.draws = [];
      this.map = [];
      this.teams = {};
      this.init();
    }
    Map.prototype.draw = function(ctx) {
      return ctx.drawImage(this.drawCache, 0, 0);
    };
    Map.prototype.isCollidingPoint = function(point) {
      var row, x, y;
      if (point[1] < 0 || point[0] < 0) {
        return false;
      }
      x = Math.round(point[0]);
      y = Math.round(point[1]);
      row = this.map[y];
      if (!row) {
        return false;
      }
      return row[x];
    };
    Map.prototype.positionForTeam = function(team) {
      var teamArray, teamIndex;
      teamIndex = Map.TEAMS[team];
      teamArray = this.teams[teamIndex];
      return teamArray.randomItem();
    };
    Map.prototype.init = function() {
      var bs, col, i, mapRow, row, tempCanvas, tempContext, x, y, _base, _len, _len2, _ref, _ref2;
      bs = 10;
      tempCanvas = document.createElement("canvas");
      tempCanvas.width = MiniWar.MAP_SIZE;
      tempCanvas.height = MiniWar.MAP_SIZE;
      tempContext = tempCanvas.getContext("2d");
      tempContext.fillStyle = MiniWar.BRICK_COLOR;
      _ref = this.mapData;
      for (y = 0, _len = _ref.length; y < _len; y++) {
        row = _ref[y];
        mapRow = [];
        _ref2 = row.split('');
        for (x = 0, _len2 = _ref2.length; x < _len2; x++) {
          col = _ref2[x];
          i = bs;
          if (col === '#') {
            while (i-- > 0) {
              mapRow.push(true);
            }
            tempContext.fillRect(x * bs, y * bs, bs, bs);
          } else {
            if (col !== ' ') {
              (_base = this.teams)[col] || (_base[col] = []);
              this.teams[col].push([x * bs, y * bs]);
            }
            while (i-- > 0) {
              mapRow.push(false);
            }
          }
        }
        i = bs;
        while (i-- > 0) {
          this.map.push(mapRow);
        }
      }
      return this.drawCache = tempCanvas;
    };
    return Map;
  })();
  window.Map = Map;
}).call(this);
