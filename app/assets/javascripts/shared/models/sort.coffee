class App.Model.Sort
  sort_type: 'recent'
  sorts:
    recent: (event) -> event.get('start')
    popular: (event) -> -window.event_list_container_view.votes.votes_hash[event.id].votes['point']
    business: (event)-> event.businessName()

  constructor: (@event_container)->

  setSortType: (type)->
    @sort_type = type
    @event_container.event_list.comparator = @sorts[type]
    @event_container.event_list.sort()

