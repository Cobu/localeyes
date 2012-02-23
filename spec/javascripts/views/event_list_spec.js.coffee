#= require consumer/application
#= require factories/models

describe 'ConsumerEventsView', ->

  beforeEach( ->
    loadFixtures 'event_list_page.html'
    @view = window.consumer_events_view = new App.View.ConsumerEventsView().render()
  )

  it 'creates container view', ->
    try
      data = {
        businesses: window.cafe_business.toJSON(),
        events: [
          {
            id: "2",
            title: "whole day fiesta",
            description: "Description for whole day fiesta goes here. There might be spontaneous scrabble game or a guitar jam",
            start: "2012-02-10 10:15:00",
            end: '2012-02-10 22:00:00 UTC',
            business_id: 3,
            service_type: "event_type"
          }
        ]
      }
      @view.reset(data)
      expect($('#jasmine-fixtures')).toContain('.legend')
      expect($('.legend')).toBeVisible()
    catch ex
      alert(ex)
