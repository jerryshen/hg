document.addEventListener "turbolinks:load", () ->

  bindGuokeEditor("/admin/global_images")

  $('.ajax-popup').fancybox ->

  $(document).on 'click', '.fancy-close', () =>
    $.fancybox.close()

  $('.select2').select2()

  $('.dropdown-toggle').dropdownHover()

  $('.datetimepicker').datetimepicker
    language:'zh-CN'
    format: 'yyyy-mm-dd hh:ii'
    autoclose: true

  $(document).on 'click', '.dialog-type-list .table tr', (e) ->
    $(this).find('input').trigger 'click'

  $(document).on 'click', '.dialog-type-list .table tr input[type=radio]', (e) ->
    e.stopPropagation()
    return

  $(document).on 'click', '.js-refresh-captcha', () ->
    url = $(@).data('url') + '?timestamp=' + Date.now().toString()
    $(@).attr 'src', url

  $('.dialog-type-list .table tr:eq(2)').trigger 'click'

  $('.js-details-menu li a').click ->
    hr = $(this).attr('href')
    anh = $(hr).offset().top - 60
    $('html,body').stop().animate { scrollTop: anh }, 600
    return false

  $('.address-item input:checked').parent('.address-item').addClass 'active'

  $(document).on 'click', '.address-item .whole-label', (e) ->
    $(this).parent('.address-item').addClass 'active'
    $(this).parent('.address-item').siblings(".address-item").removeClass 'active'

  $windowHeight = $(window).height()
  $resetHeight = $windowHeight - 47
  $(".feed-main,.full-main").css "min-height", $resetHeight + "px"
  return

