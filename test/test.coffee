should = require('chai').should()
Entity = require '../src/entity'

describe 'Entity.Componentize', ->
  it 'should create a new Component class from a class', ->
    Component = Entity.Componentize(class Component)

    Clas = Entity.Class(Component)
    entity = new Clas()

    component = entity._components[Component._id]
    component._entity.should.equal entity

  it 'should sync the entity with the component variables', ->
    Component = Entity.Componentize(
      class Component
        position:
          x: 1
          y: 1)
      .sync('position')

    Clas = Entity.Class(Component)
    entity = new Clas()

    component = entity._components[Component._id]
    entity.position.should.equal component.position

    position = component.position = 
      x: 2
      y: 2
    
    entity.position.should.equal position
    component.__position.should.equal position

describe 'Entity.Class', ->
  it 'should create a new componentless Entity which builds correctly', ->
    Clas = Entity.Class([])

    entity = new Clas()
    entity.context.should.equal entity

  it 'should create a new Entity with a dummy component', ->
    Component = Entity.Componentize(class Component)

    Clas = Entity.Class(Component)
    entity = new Clas()

    entity._components[Component._id]._entity.should.equal entity
    entity._components[Component._id].should.be.instanceof Component

  it 'should correctly bind events defined using on', ->
    ticked = false

    Component = Entity.Componentize(
      class Component
        tick: ()->
          ticked = true)
      .listensTo('tick')

    Clas = Entity.Class(Component)

    entity = new Clas()

    Clas.prototype.tick.should.exist
    entity.tick()

    ticked.should.be.true

  it 'should be reactive to observed values', ->
    varChanges = 0
    aValue = 0
    bValue = 0

    Component = Entity.Componentize(
      class Component
        change: (a, b)->
          varChanges++  
          aValue = a
          bValue = b)
      .observes(change: ['a', 'b'])

    Clas = Entity.Class(Component)

    entity = new Clas()

    entity.a = 100

    aValue.should.equal 100
    #bValue.should.equal -1
    entity.__a.should.equal 100
    entity.a.should.equal 100
    varChanges.should.equal 1

    entity.b = 200

    aValue.should.equal 100
    bValue.should.equal 200
    entity.__b.should.equal 200
    entity.b.should.equal 200
    varChanges.should.equal 2

  it 'should be reactive to synced values', ->
    varChanges = 0
    aValue = 0

    Component1 = Entity.Componentize(
      class Component1
        a: -1
        change: (a)->
          @a = a
          aValue = a
          varChanges++)
      .observes(change: 'a')

    Component2 = Entity.Componentize(
      class Component2
        a: 100)
      .sync('a')

    Clas = Entity.Class([Component1, Component2])

    entity = new Clas()
    component1 = entity._components[Component1._id]
    component2 = entity._components[Component2._id]

    aValue.should.equal 100
    component1.a.should.equal 100
    component2.__a.should.equal 100
    component2.a.should.equal 100
    entity.__a.should.equal 100
    entity.a.should.equal 100
    varChanges.should.equal 1

    component2.a = 200
    
    aValue.should.equal 200
    component1.a.should.equal 200
    component2.__a.should.equal 200
    component2.a.should.equal 200
    entity.__a.should.equal 200
    entity.a.should.equal 200
    varChanges.should.equal 2