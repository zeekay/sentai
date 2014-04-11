// Generated by CoffeeScript 1.3.1
(function() {
  var Entity, should,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  should = require('chai').should();

  Entity = require('./Entity');

  describe('Entity.Class', function() {
    it('should create a new componentless Entity which builds correctly', function() {
      var Clas, entity;
      Clas = Entity.Class([]);
      entity = new Clas();
      return entity.context.should.equal(entity);
    });
    it('should create a new Entity with a dummy component', function() {
      var Clas, Component1, entity;
      Component1 = (function(_super) {

        __extends(Component1, _super);

        Component1.name = 'Component1';

        function Component1() {
          return Component1.__super__.constructor.apply(this, arguments);
        }

        return Component1;

      })(Entity.Component);
      Clas = Entity.Class([Component1]);
      entity = new Clas();
      entity._components['Component1'].entity.should.equal(entity);
      return entity._components['Component1'].should.be["instanceof"](Component1);
    });
    it('should correctly bind events defined using on', function() {
      var Clas, Component1, entity, ticked;
      ticked = false;
      Component1 = (function(_super) {

        __extends(Component1, _super);

        Component1.name = 'Component1';

        function Component1() {
          return Component1.__super__.constructor.apply(this, arguments);
        }

        Component1.prototype.on = ['tick'];

        Component1.prototype.tick = function() {
          return ticked = true;
        };

        return Component1;

      })(Entity.Component);
      Clas = Entity.Class([Component1]);
      entity = new Clas();
      entity.tick.should.exist;
      entity.tick();
      return ticked.should.be["true"];
    });
    return it('should be reactive to observed values values', function() {
      var Clas, Component1, entity, varChanges;
      varChanges = 0;
      Component1 = (function(_super) {

        __extends(Component1, _super);

        Component1.name = 'Component1';

        function Component1() {
          return Component1.__super__.constructor.apply(this, arguments);
        }

        Component1.prototype.on = ['tick'];

        Component1.prototype.obs = {
          change: ['a', 'b']
        };

        Component1.prototype.change = function() {
          return varChanges++;
        };

        return Component1;

      })(Entity.Component);
      Clas = Entity.Class([Component1]);
      entity = new Clas();
      entity.a = 100;
      entity.__a.should.equal(100);
      entity.a.should.equal(100);
      varChanges.should.equal(1);
      entity.b = 200;
      entity.__b.should.equal(200);
      entity.b.should.equal(200);
      return varChanges.should.equal(2);
    });
  });

}).call(this);