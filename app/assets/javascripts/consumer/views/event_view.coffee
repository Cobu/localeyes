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
    @container_view = options.event_container_view
    @business_list = @container_view.business_list
    suffix = if @container_view.logged_in then 'logged_in' else 'guest'
    @template = JST["consumer/event_#{suffix}"]
    @render()

  showBusiness: ->
    if ( @cid == (@business_list.selected_view.event_view.cid if @business_list.selected_view) )
      @business_list.clearSelected()
    else
      @business_list.clearSelected()
      bview = new App.View.BusinessView(event_view: this)
      @business_list.setSelected(@model.business().get('id'), bview)

  hoverHandler: => @elem.toggleClass('hover')

  selectFavoriteHandler: =>
    business_id = @elem.data('business_id')
    selected = @container_view.filter.setFavorite( business_id )
    prefix = if selected then '' else 'un'
    $("img[data-business_id='#{business_id}']").attr({src: "assets/fav_#{prefix}selected.png"})

  voteHandler: (event)=>
    img = $(event.currentTarget)
    vote = img.data('vote')
    event_id = @elem.data('id')
    $.post('/users/event_vote', { event: event_id, vote: vote }, (data)=>
      # returns null if already voted .. TODO  might want to show a message for this case
        @container_view.votes.resetVotes(data) if data
    )

  render: ->
    if @model
      @elem = $(@el).html(@template(@model))
      @elem.attr('data-id', @model.get('id'))
      @elem.attr('data-business_id', @model.get('business_id'))
    this



