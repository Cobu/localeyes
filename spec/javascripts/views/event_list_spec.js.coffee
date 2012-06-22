#= require consumer/application

describe 'ConsumerEventsView', ->

  s = new Shared()
  start_time = null

  beforeEach ->
    start_time = new Date().add( hours: 9 )
    data = Data.createBusiness(start_time)
    console.log data

    s.setUp('event_list_page.html')

    s.view.reset(data)

  afterEach ->
    s.restoreClock()

  it 'creates container view', ->
    expect($('.legend')).toBeVisible()

    expect($('.event')).toExist()
    $('.event .wrapper .info_bar .info').click()

    expect($('.business')).toBeVisible()
    $('.event .wrapper .info_bar .info').click()

    s.tick(1000)
    expect($('.business')).not.toBeVisible()

    $('.event .wrapper .info_bar .info').click()

    expect($('.business')).toBeVisible()

    $('.event .wrapper .info_bar .info').click()
    s.tick(500)
    expect($('.business')).not.toBeVisible()


