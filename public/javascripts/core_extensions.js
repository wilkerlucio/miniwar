(function() {
  Date.currentTime = function() {
    return (new Date()).getTime();
  };
  Array.prototype.filter = function(iterator) {
    var item, newArray, _i, _len;
    newArray = [];
    for (_i = 0, _len = this.length; _i < _len; _i++) {
      item = this[_i];
      if (iterator(item)) {
        newArray.push(item);
      }
    }
    return newArray;
  };
  Array.prototype.randomItem = function() {
    var index;
    index = Math.floor(Math.random() * this.length);
    return this[index];
  };
}).call(this);
