// Generated by CoffeeScript 1.3.3
var Blur, Rendernode, SSAO;

Rendernode = require('/rendernode');

Blur = require('/blur');

return SSAO = (function() {

  function SSAO(gl, normaldepth) {
    this.normaldepth = normaldepth;
    this.moments = new Rendernode(gl, {
      program: get('moments.shader'),
      type: gl.FLOAT,
      drawable: quad
    });
    this.blur = new Blur(gl, {
      type: gl.FLOAT
    });
    this.output = new Rendernode(gl, {
      program: get('ssao.shader'),
      drawable: quad
    });
  }

  SSAO.prototype.update = function() {
    this.moments.start().sampler('normaldepth', this.normaldepth).f('range', 42).clear().draw().end();
    this.blur.update(this.moments);
    return this.output.start().sampler('normaldepth', this.normaldepth).sampler('momentsmap', this.blur.output).f('range', 42).clear().draw().end();
  };

  SSAO.prototype.resize = function(width, height) {
    this.moments.resize(width / 2, height / 2);
    this.blur.resize(width / 4, height / 4);
    return this.output.resize(width, height);
  };

  return SSAO;

})();
