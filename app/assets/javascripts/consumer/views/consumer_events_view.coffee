class App.View.ConsumerEventsView extends Backbone.View

  initialize: ->
    @el = $('#content.consumer_events')

    @sorter = new App.Model.Sort(this)
    @votes = new App.Model.Vote(this)
    @filter = new App.Model.Filter()

    @business_list = new App.Collection.BusinessList([])
    @event_list = new App.Collection.EventList([])

    @event_list_view = new App.View.EventListView(collection: @event_list, consumer_events_view: this)
    @map_container_view = new App.View.MapContainerView(business_list: @business_list, consumer_events_view: this)

  render: ->
    $(@el).empty()
      .append( @event_list_view.el )
      .append( @map_container_view.el )
    @event_list_view.render()
    @map_container_view.render()
    this

  refresh: (data)->
    @logged_in = data.in
    @filter.set( user_favorites:data.favorites )
    @map_container_view.map_view.center_point = data.center
    @business_list.reset(data.businesses)
    @votes.setVotes(data.votes)
    @event_list.reset(data.events)

