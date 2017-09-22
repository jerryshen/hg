class @MainUploader
  constructor: (opts) ->
    uploader = new plupload.Uploader
      runtimes        : 'html5, flash, html4'
      browse_button   : opts.button
      max_file_size   : '5mb'
      url             : opts.url
      flash_swf_url   : '/uploader.swf'
      filters         : [
        {title : "图片文件", extensions : "jpg,gif,png,bmp,jpeg"}
      ]
      file_data_name  : 'data'
      multipart       : true
      multi_selection : false
      multipart_params:
        authenticity_token: $('meta[name="csrf-token"]').attr('content')

    uploader.init()

    uploader.bind 'FilesAdded', (up, files) ->
      # parent = $("##{opts.button}").parents('.upload')
      # $('.img-holder', parent).html("<div class=\"uploading\" style=\"width:120px;height:120px\"><span class=\"g-block\"><b>0%</b></span></div>")
      uploader.start()

    uploader.bind "BeforeUpload", (up, file) ->
      up.settings.multipart_params =
        target: opts.button
        target_type: $("##{opts.button}").parents('.upload').data('target-type')
        authenticity_token: $('meta[name="csrf-token"]').attr('content')

    uploader.bind 'Error', (up, err) ->
      up.refresh()

    uploader.bind 'UploadProgress', (up, file) ->
      text = file.percent + '%'
      $("##{opts.button}").parents('.upload').find('p.g-block b').html(text)

    uploader.bind 'FileUploaded', (up, file, data) ->
      eval(data.response)
