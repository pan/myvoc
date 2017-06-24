$ ->
  # click a word showing its definition
  $(document).on 'click', 'li .word', ->
    wid = this.id
    $(".current").removeClass("current")
    $(this).addClass("current")
    $.get "/words/#{wid}", (data) ->
      $('#dcontainer').replaceWith data

  # fetch suggested word from this url
  src = "/words/suggested.json/"
  # IE utf8 wordaround is not needed for english word searching
  submit_without_utf8 = ->
    $("input[name='utf8']").remove()
    $("#search-form").submit()

  # autocomplete for word searching
  document.addEventListener 'turbolinks:load', ->
    $("#term").autocomplete {
      source: src,
      select: (event, ui) ->
        if ui.item
          $("#term").val(ui.item.value)
          submit_without_utf8()
      }

  # clean the url while searching words with enter key
  $("#term").keydown (event) ->
    if event.which == 13
      submit_without_utf8()

  # add a new word by clicking the plus sign
  $(document).on 'click', '.add-word', ->
    if $("#term").val()
      authtoken = $("meta[name=csrf-token]").attr("content")
      hidden_token = "<input name='authenticity_token' type='hidden' \
        value=#{authtoken}>"
      $("#search-form").attr("method", "post")
      $("#search-form").append(hidden_token)
      $("#search-form").submit()

  # play the pronunciation by clicking the ipa button
  $(document).on 'click', 'button.bt', ->
    pron = $(this).children("audio")[0]
    pron.play()

  # handle the word delete event data
  $(".delsym").on "ajax:success", (e, deleted, status, xhr) ->
    $("##{deleted.id}").parent().remove()

  # handle word list upload event
  $("input[type=file]").change ->
    filename = $(this).val().replace(/.*[\/\\]/, '')
    if filename?
      $(this).next(".custom-file-control").attr('data-content', filename)
