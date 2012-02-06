#= require application

describe 'ConsumerEventsView', ->
  beforeEach( -> console.log(1) )


  it 'should exist', ->
    expect(new App.Models.Event).toBeDefined()

  it 'creates container view', ->
    console.log(2)