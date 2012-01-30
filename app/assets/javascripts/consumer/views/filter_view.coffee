class window.Filter
  @serviceTypes = [0, 1, 2, 3]
  @filtering_favorites = false
  @userFavorites = []

  setServiceType: (selected, value)->
    value = parseInt(value)
    index = _.indexOf(Filter.serviceTypes, value)
    if selected
      Filter.serviceTypes.push( value ) unless index >= 0
    else
      Filter.serviceTypes.splice( index ,1)
    window.event_list_view.render()
    window.map_view.render()

  setFilteringByFavorites: (bool)->
    Filter.filtering_favorites = bool
    window.event_list_view.render()
    window.map_view.render()

  setFavorite: (business_id)->
    selected = true
    if _.include(Filter.userFavorites, business_id)
      $.post('/users/unset_favorite', { b: business_id})
      Filter.userFavorites = _.without(Filter.userFavorites, business_id)
      selected = false
    else
      Filter.userFavorites.push(business_id)
      $.post('/users/set_favorite', { b: business_id})
    selected

  match: (business)->
    if Filter.filtering_favorites then return false unless _.include(Filter.userFavorites, business.get('id'))
    _.include(Filter.serviceTypes, business.get('service_type'))

  setValues: ->
    $('.filter input[name^=service_type]').each((index, elem)->
        selected = _.indexOf(Filter.serviceTypes, $(elem).val())
        $(elem).prop('checked', selected )
    )

window.filter = new window.Filter()
