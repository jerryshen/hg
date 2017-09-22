class @ItemMultipleUploader
  constructor: (opts) ->
    uploader = new plupload.Uploader
      runtimes        : 'html5, flash'
      browse_button   : opts.button
      max_file_size   : '10mb'
      url             : opts.url
      flash_swf_url   : '/uploader.swf'
      filters         : [
          {title : "图片文件", extensions : "jpg,gif,png,bmp"}
      ]
      file_data_name  : 'data'
      multipart       : true
      multipart_params:
        authenticity_token: $('meta[name="csrf-token"]').attr('content')

    uploader.init()

    uploader.bind 'FilesAdded', (up, files) ->
      # uploaded_files = $('.js-single-image-parent').length
      # uploaded_files = $('.upload-items-list > :visible').length || $('.upload-items-list > li').length
      # selected_fiels = files.length

      # if selected_fiels + uploaded_files > 8
      #   alert('只能上传8张图片')
      #   return false

      $(
        ("<div class=\"fields\"><li class=\"photo uploading\" id=\"#{file.id}\">
            <div class=\"g-block\"><b>0%</b></div>
          </li></div>" for file in files).join('')
      ).appendTo('#photos')

      uploader.start()

    uploader.bind "BeforeUpload", (up, file) ->
      uploader.settings.multipart_params =
        file_id: file.id
        target: opts.button
        type_identifier: 'item_multiple'
        authenticity_token: $('meta[name="csrf-token"]').attr('content')

    uploader.bind 'Error', (up, err) ->
      up.refresh()

    uploader.bind 'UploadProgress', (up, file) ->
      text = file.percent + '%'
      $("##{file.id} .g-block b").html(text)

    uploader.bind 'FileUploaded', (up, file, data) ->
      eval(data.response)

