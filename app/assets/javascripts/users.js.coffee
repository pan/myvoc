$ ->
  # log on/off
  $("#log-button").click ->
    stat = $("#log-status")
    logon = stat.attr("class").contains("logon")
    if logon
      $.get "logout"
      stat.removeClass("logon").removeClass("logon-ani")
      stat.addClass("logoff-ani").addClass("logoff")
      stat.text "Logged off"
      $(".username").text("")
      $("#oauth").hide()
    else
      stat.removeClass("logoff").removeClass("logoff-ani")
      stat.addClass("logon-ani").addClass("logon")
      stat.text "Login with"
      $("#oauth").slideDown()
