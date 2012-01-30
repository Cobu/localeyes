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





