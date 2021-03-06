// Generated by CoffeeScript 1.3.3
var Quad,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

return Quad = (function(_super) {

  __extends(Quad, _super);

  Quad.prototype.attribs = ['position'];

  Quad.prototype.pointers = [
    {
      name: 'position',
      size: 2,
      offset: 0,
      stride: 2
    }
  ];

  function Quad(gl) {
    var vertices;
    this.gl = gl;
    Quad.__super__.constructor.call(this);
    this.size = 6;
    vertices = [-1, -1, 1, -1, 1, 1, -1, -1, 1, 1, -1, 1];
    this.uploadList(vertices);
  }

  return Quad;

})(require('drawable'));
