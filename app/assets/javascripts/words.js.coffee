$ ->
  # click a word showing its definition
  $("li .word").click ->
    wid = this.id
    $.get "/words/#{wid}", (data) ->
      $('#dcontainer').replaceWith data

  # fetch suggested word from this url
  src = "/words/suggested.json/"
  # authenticity_token is not needed for read operation
  # IE utf8 wordaround is not needed for english word searching
  submit_without_token = ->
    $("#authenticity_token").remove()
    $("input[name='utf8']").remove()
    $("#search-form").submit()

  # autocomplete for word searching
  $("#search").autocomplete {
    source: src,
    select: (event, ui) ->
      if ui.item
        $("#search").val(ui.item.value)
        submit_without_token()
    }

  # clean the url while searching words with enter key
  $("#search").keydown (event) ->
    if event.which == 13
      submit_without_token()

  # add a new word by clicking the plus sign
  $(".add-word").click ->
    if $("#search").val()
      $("#search-form").attr("method", "post")
      $("#search-form").submit()
