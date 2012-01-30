class App.View.BusinessView extends Backbone.View
  event_view: null
  tagName: 'li'
  className: 'business'

  initialize: (options)->
    @event_view = options.event_view
    @template = JST['consumer/business_info']
    @render()

  render: ->
    @elem = $(@el).html(@template(@event_view.model.business())).hide()
    @event_view.elem.after(@elem)
    @event_view.elem.find('.description').addClass('open').show()
    @elem.slideDown('slow', =>
      # bold the day of the week on the hours list
        day_number = @event_view.date.getDay()
        @$(".line[data-day_num=#{day_number}]").addClass('bold')
    )

  close: ->
    @elem.slideUp('slow', =>
        @event_view.elem.find('.description').hide()
        @event_view.elem.removeClass('open')
        @elem.remove()
    )



