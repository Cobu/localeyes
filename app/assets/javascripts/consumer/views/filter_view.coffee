class App.View.FilterView extends Backbone.View
  className: 'filter'
  open: true

  events:
    'click input[name^=service_type]': 'filterServiceTypeHandler'
    'click .close': 'toggle'

  initialize: ->
    @filter = @model
    @template = JST['consumer/filter']

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
    @open = !@open
    $('.link[data-type=filter]').trigger('click')

  render: ->
    $(@el).html( @template() ).toggle(@open)
    @setValues()
    this

