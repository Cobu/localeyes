class App.View.EventDayHeaderView extends Backbone.View
  tagName: 'li'
  className: 'day_header'
  template: Handlebars.compile "{{header date}}"

  initialize: (options)->
    @date = options.date
    @render()

  render: ->
    html = @template(date: @date)
    @elem = $(@el).html(html).attr('data-role', 'list-divider')




Handlebars.registerHelper("header", (date)->
    return unless _.isDate(date)
    str = if date.equals(Date.today())
      "Today"
    else if date.equals(Date.today().addDays(1))
      "Tommorrow"
    else
      date.toString('dddd')
    str += " #{date.toString('MMMM dS')}"
)
