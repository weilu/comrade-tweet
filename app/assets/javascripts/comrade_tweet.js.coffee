$(->
  $('.btn-success').on('click', ->
    row = $(this).closest('.message')
    originalMessage = $('.message-body', row).text().trim()
    attribution = ' via ' + $('.sender-handle', row).text()

    $('#moo .modal-body textarea').val(originalMessage + attribution)

    $('#moo').modal()
  )
)