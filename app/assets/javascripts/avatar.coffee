$(document).ready ->

  $('#user_avatar').change ->
    if this.files and this.files[0]
      reader = new FileReader
      reader.onload = (e) ->
        $('.avatar_thumb').attr('src', e.target.result).width(150).height(150)
        return
      reader.readAsDataURL this.files[0]

  $('#comment_files').change ->
    if this.files and this.files[0]
      $.each this.files, (index, value) ->
        reader = new FileReader
        reader.onload = (e) ->
          if e.target.result.split('data:')[1].split('/')[0] == 'image'
            $('#files_comment').append('<div class = "comment_pics"><img src = '+e.target.result+' /></div>')
          else
            $('#files_comment').append('<div class = "comment_pics"><img src = "http://findicons.com/files/icons/1580/devine_icons_part_2/128/defult_text.png" /></div>')
        reader.readAsDataURL value

#      reader.readAsDataURL this.files[0]