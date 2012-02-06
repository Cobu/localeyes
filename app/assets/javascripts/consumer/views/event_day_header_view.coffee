class App.View.EventDayHeaderView extends Backbone.View
  tagName: 'li'
  className: 'day_header'

  initialize: (options)->
    @date = options.date

  render: ->
    $(@el).html( @dateView() ).attr('data-role', 'list-divider')
    this

  dateView: ->
    return unless _.isDate(@date)
    str = if @date.equals(Date.today())
      "Today"
    else if @date.equals(Date.today().addDays(1))
      "Tommorrow"
    else
      @date.toString('dddd')
    str += " #{@date.toString('MMMM dS')}"
