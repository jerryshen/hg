window.isValidTaobaoUrl = (url) ->
  pattern = /http:\/\/.*?[taobao|tmall]\.com\/.*?&id=\d+/
  if url.length > 0
    pattern.test url
  else
    true

is_valid_id_card = (num) ->
  pattern = /^((11|12|13|14|15|21|22|23|31|32|33|34|35|36|37|41|42|43|44|45|46|50|51|52|53|54|61|62|63|64|65|71|81|82|91)\d{4})((((19|20)(([02468][048])|([13579][26]))0229))|((20[0-9][0-9])|(19[0-9][0-9]))((((0[1-9])|(1[0-2]))((0[1-9])|(1\d)|(2[0-8])))|((((0[1,3-9])|(1[0-2]))(29|30))|(((0[13578])|(1[02]))31))))((\d{3}(x|X))|(\d{4}))$/
  if pattern.test(num)
    y = (parseInt(num[0])  * 7   +
         parseInt(num[1])  * 9   +
         parseInt(num[2])  * 10  +
         parseInt(num[3])  * 5   +
         parseInt(num[4])  * 8   +
         parseInt(num[5])  * 4   +
         parseInt(num[6])  * 2   +
         parseInt(num[7])  * 1   +
         parseInt(num[8])  * 6   +
         parseInt(num[9])  * 3   +
         parseInt(num[10]) * 7  +
         parseInt(num[11]) * 9  +
         parseInt(num[12]) * 10 +
         parseInt(num[13]) * 5  +
         parseInt(num[14]) * 8  +
         parseInt(num[15]) * 4  +
         parseInt(num[16]) * 2) % 11

    x = switch y
      when 0  then '1'
      when 1  then '0'
      when 2  then 'x'
      when 3  then '9'
      when 4  then '8'
      when 5  then '7'
      when 6  then '6'
      when 7  then '5'
      when 8  then '4'
      when 9  then '3'
      when 10 then '2'

    num[17] == x
  else
    false

$ ->
  $.validator.setDefaults
    highlight: (element) -> false
    unhighlight: (element) -> false
    errorElement: 'span'
    errorClass: 'help-inline'
    validClass: 'help-block'
    errorPlacement: (error, element) ->
      element.parent().find('.help-block').remove()
      if element.parent('.input-group').length
        error.insertAfter(element.parent())
      else if element.parent('.redactor_box').length
        element.parents('.controls').append(error)
      else
        error.insertAfter(element)
    success: (label, element) ->
      parent = label.parent()
      $(label).remove()
      if !$(parent).hasClass('photo_ids') and !$(parent).hasClass('ignore-success-info') and !$(parent).parents('form').hasClass('ignore-success-info')
        parent.append('<span class=\"help-block\"></span>').show()
    onkeyup: false
    onfocusout: (element, event) -> $(element).valid()
    ignore: '.ignore'

  jQuery.validator.addMethod "mintags", (value, element, params) ->
    $(element).tagCount() >= params

  jQuery.validator.addMethod "idCard", (value, element, params) ->
    switch value.length
      when 15
        true
      when 18
        is_valid_id_card(value.toLowerCase())
      else
        false

  jQuery.validator.addMethod "taobaoUrl", (value, element, params) ->
    isValidTaobaoUrl(value)

  jQuery.validator.addMethod "minSelect", (value, element, params) ->
    selectContainer = $('.select2-container' ,$(element).parents('.form-group'))
    $('li.select2-search-choice', selectContainer).length >= params

  jQuery.validator.addMethod "subdomainLimit", (value, element, params) ->
    pattern = /^[a-z0-9]+$/
    pattern.test value.toLowerCase()

  jQuery.validator.addMethod "mobileCheck", (value, element, params) ->
    pattern = window.mobile_phone_regexp
    pattern.test value

  jQuery.validator.addMethod "minItemPhoto", (value, element, params) ->
    min = params.min
    parent = params.parent
    ids = []
    for item in $("#{params.selector}")
      if parent
        if $(item).parents(parent).is(':visible')
          v = item.value
          if v != "" then ids.push(v)
      else
        if $(item).parents('.fields').is(':visible')
          v = item.value
          if v != "" then ids.push(v)
    ids.length >= min

  jQuery.validator.addMethod "notEqual", (value, element, param) ->
    return this.optional(element) || value != $(param).val();


  $.validator.messages =
    required: "不能为空",
    remote: "请输入这些项",
    email: "请输入一个有效的email地址",
    url: "请输入一个有效的Url地址",
    date: "请输入一个有效的日期",
    dateISO: "Please enter a valid date (ISO).",
    dateDE: "Bitte geben Sie ein gültiges Datum ein.",
    number: "请输入一个有效的数字",
    numberDE: "Bitte geben Sie eine Nummer ein.",
    digits: "只能输入数字",
    creditcard: "请输入有效信用卡号码",
    equalTo: "请再次输入相同的值",
    notEqual: "请输入一个新的值",
    accept: "请输入一个有效的扩展名.",
    maxlength: $.format("最多能输入 {0} 个字符"),
    minlength: $.format("请输入至少 {0} 个字符"),
    rangelength: $.format("请输入从{0} 到 {1} 字符长度"),
    range: $.format("请输入从 {0} 到 {1}."),
    max: $.format("请输入一个小于等于 {0} 的值."),
    min: $.format("请输入一个大于等于 {0} 的值.")
    minTags: $.format("请输入至少 {0} 个标签.")
    idCard: $.format("请输入正确的身份证号码.")
    taobaoUrl: $.format("请输入淘宝或天猫的商品页面.")
    minSelect: $.format("至少选择一个项")
    subdomainLimit: $.format("子域名必须为英文字母或者数字")
    mobileCheck: $.format("请输入正确的手机号码")
    minItemPhoto: (param) -> $.format("请上传至少#{param.min}张图片")
