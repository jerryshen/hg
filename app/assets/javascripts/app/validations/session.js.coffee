class @SessionValidator
  constructor: ->
    @new_user()

  new_user: ->
    smsBtn = $('.btn-sms')
    $('#new_user').validate
      rules:
        'user[name]':                  { required: true, minlength: 2, maxlength: 14, remote: '/valid/name' }
        'user[password]':              { required: true, minlength: 6 }
        'user[mobile_phone]':
          required: true,
          remote:
            url: '/valid/mobile_phone'
            complete: (data) ->
              if (data.responseText == 'true')
                $(smsBtn).prop("disabled", false)