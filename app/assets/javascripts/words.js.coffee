$ ->
  $("li .word").click ->
    wid = $(this).attr("id")
    $.get "/words/#{wid}", (data) ->
      $('#dcontainer').replaceWith data
