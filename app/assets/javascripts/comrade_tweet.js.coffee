window.comrade = {
  reset: ->
    window.comrade.current_message = undefined
    window.comrade.hide_current = false
}

$(->
  $('.btn-success').on('click', ->
    window.comrade.current_message = $(this).closest('.message')
    originalMessage = $('.message-body', window.comrade.current_message).text().trim()
    attribution = ' via ' + $('.sender-handle', window.comrade.current_message).text()

    $('#moo .modal-body textarea').val(originalMessage + attribution)

    $('#moo').modal()
  )

  $('.btn-danger').on('click', ->
    window.comrade.current_message = $(this).closest('.message')

    $.ajax({
      url: '/reject',
      type: 'POST',
      data: { id: window.comrade.current_message.data().id },
      success: (data) ->
        window.comrade.current_message.fadeOut('slow')
        window.comrade.reset()
    })
  )

  $('#moo .btn-primary').on('click', ->
    $.ajax({
      url: '/approve',
      type: 'POST',
      data: { id: window.comrade.current_message.data().id, text: $('#moo .modal-body textarea').val() },
      success: (data) ->
        window.comrade.hide_current = true
        $('#moo').modal('hide')
    })
  )

  $('#moo').on('hidden', ->
    if(window.comrade.hide_current)
      window.comrade.current_message.fadeOut('slow')
      window.comrade.reset()
  )
)