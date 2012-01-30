Handlebars.registerHelper("rounded", (number)->
    if (number != undefined)
      parseFloat(number).toFixed(2)
)

Handlebars.registerHelper("hour", (string)->
    return unless _.isString(string)
    date = Date.parseExact(string, "yyyy-MM-ddTH:mm:ssZ")
    if date then date.toString('h:mm tt') else ''
)

Handlebars.registerHelper("format_ymd_date", (date)->
    if date then date.toString('yyyy-MM-dd') else ''
)

Handlebars.registerHelper("phone_format", (phone) ->
    return if _.isEmpty(phone)
    phone = phone.toString()
    "(" + phone.substr(0, 3) + ") " + phone.substr(3, 3) + "-" + phone.substr(6, 4)
)

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



############  Event view #############
class App.View.EventView extends Backbone.View
  tagName: 'li'
  className: 'event'

  events:
    'click .wrapper .info_bar .info, .description': 'showBusiness'

  initialize: (options)->
    @date = options.date
    @logged_in = options.logged_in
    suffix = if @logged_in then 'logged_in' else 'guest'
    @template = JST["consumer/event_#{suffix}"]
    @render()

  showBusiness: ->
    if ( @cid ==  (business_list.selected_view.event_view.cid if business_list.selected_view) )
      business_list.clearSelected()
    else
      business_list.clearSelected()
      bview = new BusinessView( event_view: this )
      business_list.setSelected( @model.business().get('id'), bview )

  render: ->
    if @model
      @elem = $(@el).html( @template(@model) )
      @elem.attr('data-id', @model.get('id') )
    this

############ day header view #############
class App.View.EventDayHeaderView extends Backbone.View
  tagName: 'li'
  className: 'day_header'
  template: Handlebars.compile "{{header date}}"

  initialize: (options)->
    @date = options.date
    @render()

  render: ->
    html = @template( date:@date )
    @elem = $(@el).html( html ).attr('data-role','list-divider')

############  EventList view #############
class App.View.EventListView extends Backbone.View
  initialize: (@event_list)->
    @el = $('#event_list')
    if @event_list
      this.render()
    else
      @event_list = []
    @event_list.bind('reset', => @render())

  render: ->
    @el.empty()
    events = _(@event_list.models).groupBy((event)-> event.startDate())

    for num in [0..13]
      date = Date.today().addDays(num)
      days_events = _.select(events[date.toString("yyyy-MM-dd")], (event)-> window.filter.match(event.business()))
      continue unless _.any(days_events)
      this.buildEventsForDay(date, days_events)
    window.votes.show()


  buildEventsForDay: (date, events)->
    @el.append( new App.View.EventDayHeaderView( 'date': date).elem )
    _.each(events, (event)=>
        event_view = new App.View.EventView( model: event, date : date, logged_in: @event_list.logged_in )
        @el.append( event_view.elem )
    )


############  Business view #############
class App.View.BusinessView extends Backbone.View
  event_view: null
  tagName: 'li'
  className: 'business'

  initialize: (options)->
    @event_view = options.event_view
    @template = JST['consumer/business_info']
    @render()

  render: ->
    @elem = $(@el).html( @template(@event_view.model.business()) ).hide()
    @event_view.elem.after( @elem )
    @event_view.elem.find('.description').addClass('open').show()
    @elem.slideDown('slow', =>
      # bold the day of the week on the hours list
      day_number =  @event_view.date.getDay()
      @$(".line[data-day_num=#{day_number}]").addClass('bold')
    )

  close: ->
    @elem.slideUp('slow', =>
      @event_view.elem.find('.description').hide()
      @event_view.elem.removeClass('open')
      @elem.remove()
    )


class window.Filter
  service_type_constants = {
    service_type_cafe: 0
    service_type_restaurant: 1
    service_type_bar: 2
    service_type_retail: 3
  }
  @service_type_cafe = true
  @service_type_restaurant = true
  @service_type_bar = true
  @service_type_retail = true
  @serviceTypes = [0, 1, 2, 3]
  @filtering_favorites = false
  @userFavorites = []

  setServiceType: (type, value)->
    console.log type, value
    Filter[type] = value
    Filter.serviceTypes = []
    for name of service_type_constants
      if Filter[name] then Filter.serviceTypes.push service_type_constants[name]
    window.event_list_view.render()
    window.map_view.render()

  setFilteringByFavorites: (bool)->
    Filter.filtering_favorites = bool
    window.event_list_view.render()
    window.map_view.render()

  setFavorite: (business_id)->
    prefix = ''
    if _.include(Filter.userFavorites, business_id)
      $.post('/users/unset_favorite', { b: business_id})
      Filter.userFavorites = _.without(Filter.userFavorites, business_id)
      prefix = 'un'
    else
      Filter.userFavorites.push(business_id)
      $.post('/users/set_favorite', { b: business_id})
    img = $("img[data-business_id='#{business_id}']")
    img.attr({src:"assets/fav_#{prefix}selected.png"})


  match: (business)->
    if Filter.filtering_favorites then return false unless _.include(Filter.userFavorites, business.get('id'))
    _.include(Filter.serviceTypes, business.get('service_type'))

  setValues: ->
    $('.filter input[type=checkbox]').each((index, elem)->
        id = $(elem).attr('id')
        $(elem).prop('checked', Filter[id])
    )

window.filter = new window.Filter()

class window.Votes
  votes: []
  votes_hash: {}

  setVotes: (votes)->
    @votes = votes
    _.each(votes, (vote)=> @votes_hash[vote._id] = vote )

  show: ()-> _.each( @votes, (info)=> this.showNumbers(info) )

  resetVotes: (data)->
    @votes_hash[data._id] = data
    _.each(@votes, (info, index)=>
        if (info._id == data._id)
          @votes[index] = data
          this.showNumbers(data)
    )
    window.event_list.sort() if window.sorter.sort_type == 'popular'

  showNumbers: (info)->
    elem = $(".event[data-id='#{info._id}']")
    elem.find(".vote.up .number").html(info.votes["up_count"] || 0)
    elem.find(".vote.down .number").html(info.votes["down_count"] || 0)

window.votes = new window.Votes()


class window.Sort
  sort_type: 'recent'
  sorts: {
    recent: (event)-> event.get('start')
    popular: (event)-> -window.votes.votes_hash[event.id].votes['point']
    business: (event)-> event.businessName()
  }

  setSortType: (type)->
    @sort_type = type
    window.event_list.comparator = this.sorts[type]
    window.event_list.sort()

window.sorter = new window.Sort()


