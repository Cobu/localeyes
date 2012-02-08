#= require consumer/application

describe 'ConsumerEventsView', ->
  beforeEach( ->
  )

  it 'creates container view', ->
    loadFixtures 'event_list_page'
    view = new App.View.ConsumerEventsView()
    view.render()

    console.log $('#jasmine-fixtures')
