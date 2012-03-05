class App.View.LocationSearchView extends Backbone.View
  className: 'search'

  initialize: (options)->
    @location = options.map_view.location
    @location.bind('change', => @setLocation() )
    @template = JST['consumer/location_search']

  render: ->
    $(@el).html( @template() )
    @toggle()
    @setUpAutocomplete()
    @setLocation()
    this

  setLocation: ->
    if @location.get('center_point')
      @$("#location_search").val(@location.get('center_point').title.replace("\n",' '))

  setUpAutocomplete: ->
    @$("input#location_search").autocomplete(
      source: '/consumers/location_search'
      select: (event, ui) ->
        $("input#location_search").val(ui.item.label)
        params = {
          time:     Date.parse('now').toString('yyyy-MM-dd HH:mm')
          zip_code: ui.item.zip_code
          t:        ui.item.type
          d:        ui.item.id
        }
        $.get('/consumers/events', params , (data)=>
          window.consumer_events_view.reset(data)
        )
        return false
    )

  toggle: ->
    $('.link[data-type=search]').trigger('click')

