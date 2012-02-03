class App.Model.Filter extends Backbone.Model
  defaults:
    filtering_favorites: false
    service_types: [0, 1, 2, 3]
    user_favorites: []

  initialize: ->

  setServiceType: (selected, value) ->
    value = parseInt(value)
    service_types = _.clone(@get('service_types'))
    index = _.indexOf(service_types, value)
    if selected
      unless index >= 0
        service_types.push(value)
        @set( service_types: service_types )
    else
      service_types.splice(index, 1)
      @set( service_types: service_types )

  setFavorite: (business_id)->
    selected = true
    user_favorites = @get('user_favorites')
    if _.include(user_favorites, business_id)
      $.post('/users/unset_favorite', { b: business_id}, =>
        @set( user_favorites: _.without( user_favorites, business_id) )
      )
      selected = false
    else
      $.post('/users/set_favorite', { b: business_id}, =>
        user_favorites.push(business_id)
        @set( user_favorites: user_favorites )
      )
    selected

  match: (business)->
    _.include(@get('service_types'), business.get('service_type'))
