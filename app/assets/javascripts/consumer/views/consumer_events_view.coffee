class App.View.ConsumerEventsView extends Backbone.View

  initialize: ->
    @el = $('#content.consumer_events')

    @business_list = new App.Collection.BusinessList([])
    @event_list = new App.Collection.EventList([])

    @sorter = new App.Model.Sort(this)
    @votes = new App.Model.Vote(this)
    @filter = new App.Model.Filter()
    @location = new App.Model.Location()
    @favorites = new App.Model.Favorites(consumer_events_view: this)

    # Order is important here. FilterView in MapContainerView must be created before
    # the EventListHeaderView can detect if that FilterView is open or not
    @map_container_view = new App.View.MapContainerView(consumer_events_view: this)
    @event_list_view = new App.View.EventListView(collection: @event_list, consumer_events_view: this)

  render: ->
    $(@el).empty()
      .append( @event_list_view.render().el )
      .append( @map_container_view.el )
    @map_container_view.render()
    this

  reset: (data)->
    @logged_in = data.in
    @event_list_view.header.render()
    @favorites.set( user_favorites: data.favorites )
    @location.set( center_point: data.center )
    @business_list.reset(data.businesses)
    @votes.setVotes( data.votes )
    @event_list.reset( data.events )


  reloadData: ->
    params = {}
    $.get('consumers/events', params, (data) => @reset(data))
