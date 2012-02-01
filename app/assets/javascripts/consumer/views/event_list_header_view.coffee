class App.View.EventListHeaderView extends Backbone.View
  className: 'event_list_header'

  events:
    'click .sort_div .link' : 'sortHandler'
    'click .link_div .link' : 'linkHandler'

  linkHandler: (event)->
    elem = $(event.currentTarget)
    type = elem.data('type')
    direction = elem.data('direction')
    elem.toggleClass('selected_link')
    $( ".#{type}" ).toggle('slide', {direction: direction})

  initialize: (options)->
    @content_view = options.event_container_view
    @template = JST["consumer/event_list_header"]
    @render()

  render: ->
    $(@el).empty()
    $(@el).html( @template( {logged_in: @content_view.logged_in} ) )
    @elem = $(@el)

  sortHandler: (event)->
    elem = $(event.currentTarget)
    type = elem.data('type')
    $('.sort_div .link').removeClass('selected_link')
    elem.addClass('selected_link')
    @content_view.sorter.setSortType(type)
