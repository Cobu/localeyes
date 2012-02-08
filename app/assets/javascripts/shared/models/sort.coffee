class App.Model.Sort
  sort_type: 'recent'
  sorts:
    recent: (event) -> event.get('start')
    popular: (event) -> -window.consumer_events_view.votes.votes_hash[event.id].votes['point']
    business: (event)-> event.businessName()
    favorite: (event)-> -_.include(window.consumer_events_view.favorites.get('user_favorites'), event.get('business_id'))

  constructor: (@event_container)->

  setSortType: (type)->
    @sort_type = type
    @event_container.event_list.comparator = @sorts[type]
    @event_container.event_list.sort()

