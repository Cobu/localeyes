#= require consumer/application

describe 'ConsumerEventsView', ->
  beforeEach( -> console.log(1) )

  it 'should exist', ->
    expect(new App.Models.Event).toBeDefined()

  it 'creates container view', ->
    console.log new App.Collection.EventList