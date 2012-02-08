class App.Model.Favorites extends Backbone.Model
  defaults:
    user_favorites: []

  initialize: (options) ->
    @event_container = options.consumer_events_view

  setFavorite: (business_id) ->
    selected = true
    user_favorites = @get('user_favorites')
    if _.include(user_favorites, business_id)
      $.post('/users/unset_favorite', { b: business_id}, =>
        @set( user_favorites: _.without( user_favorites, business_id) )
        @doSort()
      )
      selected = false
    else
      $.post('/users/set_favorite', { b: business_id}, =>
        user_favorites.push(business_id)
        @set( user_favorites: user_favorites )
        @doSort()
      )
    selected

  doSort: ->
    @event_container.event_list.sort() if @event_container.sorter.sort_type == 'favorite'