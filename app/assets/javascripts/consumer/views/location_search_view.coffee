class App.View.LocationSearchView extends Backbone.View
  className: 'search'

  initialize: (options)->
    @template = JST['consumer/location_search']

  render: ->
    $(@el).html( @template() )
    @toggle()
    @setUpAutocomplete()
#    @$("#location_search").val(@$("#location_search").val().replace("\n", ' '))
    this

  setUpAutocomplete: ->
    @$("input#location_search").autocomplete(
      source: '/consumers/location_search'
      select: (event, ui) ->
        $("input#location_search").val(ui.item.label)
        params = {
          time:     Date.now().toString('yyyy-MM-dd HH:mm')
          zip_code: ui.item.zip_code
          t:        ui.item.type
          d:        ui.item.id
        }
        $.get('/consumers/events', params , (data)=>
          window.consumer_events_view.refresh(data)
        )
        return false
    )

  toggle: ->
    $(@el).toggle('slide', {direction: 'down'})
