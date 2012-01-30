class App.Controller.Events
  @refresh: (data)->
    window.map_view.center_point = data.center
    window.Filter.userFavorites = data.favorites
    window.filter.setValues()
    window.business_list.reset(data.businesses)
    window.votes.setVotes(data.votes)
    window.event_list.reset(data.events, data.in)
    $("#location_search").val(data.center.title.replace("\n", ' '))

