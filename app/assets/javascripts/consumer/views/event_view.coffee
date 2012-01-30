class App.View.EventView extends Backbone.View
  tagName: 'li'
  className: 'event'

  events:
    'click .wrapper .info_bar .info, .description': 'showBusiness'
    'hover .info, .description': 'hoverHandler'
    'click .images img[rel=favorite]': 'selectFavoriteHandler'
    'click .images img[rel=vote]': 'voteHandler'

  initialize: (options)->
    @date = options.date
    @logged_in = options.logged_in
    suffix = if @logged_in then 'logged_in' else 'guest'
    @template = JST["consumer/event_#{suffix}"]
    @render()

  showBusiness: ->
    if ( @cid == (business_list.selected_view.event_view.cid if business_list.selected_view) )
      business_list.clearSelected()
    else
      business_list.clearSelected()
      bview = new App.View.BusinessView(event_view: this)
      business_list.setSelected(@model.business().get('id'), bview)

  hoverHandler: => @elem.toggleClass('hover')
  selectFavoriteHandler: =>
    business_id = @elem.data('business_id')
    selected = filter.setFavorite( business_id )
    prefix = if selected then '' else 'un'
    $("img[data-business_id='#{business_id}']").attr({src: "assets/fav_#{prefix}selected.png"})

  voteHandler: (event)=>
    img = $(event.currentTarget)
    vote = img.data('vote')
    event_id = @elem.data('id')
    $.post('/users/event_vote', { event: event_id, vote: vote }, (data)->
      # returns null if already voted .. TODO  might want to show a message for this case
        window.votes.resetVotes(data) if data
    )


  render: ->
    if @model
      @elem = $(@el).html(@template(@model))
      @elem.attr('data-id', @model.get('id'))
      @elem.attr('data-business_id', @model.get('business_id'))
    this



window.short_dayname = ['Su', 'M', 'T', 'W', 'Th', 'F', 'Sa']
window.hours_template = Handlebars.compile("{{hour from}} - {{hour to}}")
Handlebars.registerHelper("each_hour", (array, fn)->
    buffer = ""
    for num in [0..array.length - 1]
      item = array[num]
      # add the day_name property onto the hours
      item.day_name = short_dayname[num]
      item.day_num = num
      if (item.open == true)
        item.hour_value = window.hours_template(item)
      else
        item.hour_value = "Closed"
      # show the inside of the block
      buffer += fn(item)
    buffer # return the finished buffer
)
