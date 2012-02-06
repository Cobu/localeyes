class App.View.FilterView extends Backbone.View
  className: 'filter'

  events:
    'click input[name^=service_type]': 'filterServiceTypeHandler'
    'click input[name=filtering_favorites]': 'filterFavoritesHandler'
    'click .close': 'toggle'

  initialize: ->
    @filter = @model
    @template = JST['consumer/filter']
    @setValues()

  filterServiceTypeHandler: (event) =>
    elem = $(event.currentTarget)
    @filter.setServiceType(elem.prop('checked'), elem.val())

  filterFavoritesHandler: (event) =>
    elem = $(event.currentTarget)
    @filter.setFilteringByFavorites(elem.prop('checked'))

  setValues: ->
    @$('input[name^=service_type]').each((index, elem) =>
      selected = _.indexOf(@filter.get('service_types'), $(elem).val())
      $(elem).prop('checked', selected)
    )

  toggle: ->
    $(@el).toggle('slide', {direction: 'left'})

  render: ->
    $(@el).html( @template() )
    this

