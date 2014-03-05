$ ->
  $("li .word").click ->
    wid = this.id
    $.get "/words/#{wid}", (data) ->
      $('#dcontainer').replaceWith data

  src = "/words/suggested.json/"
  $("#search").autocomplete({
    source: src,
    select: (event, ui) ->
      if ui.item
        $("#search").val(ui.item.value)
        $("#search-form").submit()
    }
  )
