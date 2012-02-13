class App.View.MapContainerView extends Backbone.View
  className: 'map_canvas_container'

  initialize: (options)->
    consumer_events_view = options.consumer_events_view
    @location_search_view = new App.View.LocationSearchView(consumer_events_view: consumer_events_view)
    @map_view = new App.View.ExtendBoundMapView(collection: consumer_events_view.business_list, consumer_events_view: consumer_events_view)
    @filter_view = new App.View.FilterView(model: consumer_events_view.filter)

  render: ->
    $(@el).append( @location_search_view.render().el )
      .append( @filter_view.render().el )
      .append( @map_view.el )
    @map_view.render()
    @filter_view.toggle()
    @location_search_view.toggle()
    this