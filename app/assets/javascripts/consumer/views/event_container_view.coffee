class App.View.EventContainerView extends Backbone.View

  initialize: (data)->
    @el = $('#event_list_container')

    @sorter = new App.Model.Sort(this)
    @votes = new App.Model.Vote(this)
    @filter = new App.Model.Filter()

    @business_list = new App.Collection.BusinessList([])
    @event_list = new App.Collection.EventList([])
    @map_view = new App.View.ExtendBoundMapView(collection: @business_list, event_container_view: this)
    @event_list_view = new App.View.EventListView(collection: @event_list, event_container_view: this)
    @filter_view = new App.View.FilterView(model: @filter)

    $('.legend').toggle('slide', {direction: 'down'})
    $('.search').toggle('slide', {direction: 'down'})
    $('.filter').toggle('slide', {direction: 'left'})

    @refresh(data) if data

    @header = new App.View.EventListHeaderView(event_container_view: this)
    @el.prepend( @header.elem )

  refresh: (data)->
    @logged_in = data.in
    @header.render()
    @map_view.center_point = data.center
    @filter.set(user_favorites:data.favorites)
    @business_list.reset(data.businesses)
    @votes.setVotes(data.votes)
    @event_list.reset(data.events)
    $("#location_search").val(data.center.title.replace("\n", ' '))
