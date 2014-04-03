$ ->
  class Switch
    constructor: (@name) ->
      @button = "##{@name}-button"
      @stat = $("##{@name}-status")
    listen: ->
      $(@button).click =>
        ison = @stat.hasClass("on")
        if ison
          @turn_off()
        else
          @turn_on()
    turn_off: ->
      @stat.removeClass("on").removeClass("on-ani")
      @stat.addClass("off-ani").addClass("off")
    turn_on: ->
      @stat.removeClass("off").removeClass("off-ani")
      @stat.addClass("on-ani").addClass("on")

  class LogonOff extends Switch
    turn_off: ->
      $.get "logout"
      super
      $(".username").text("")
      $("#oauth").hide()
      $("#admin-button").hide()
      $(".admin").hide()
    turn_on: ->
      super
      @stat.text "Login with"
      $("#oauth").slideDown()

  class AdmSwitch extends Switch
    reqon  = {"req": "on"}
    reqoff = {"req":"off"}
    turn_off: ->
      $.get "admin.json", reqoff, (res) ->
        $(".notice").text(res)
      $(".admin").hide()
      super
      @stat.text "Admin off"
    turn_on: ->
      $.get "admin.json", reqon, (res) ->
        $(".notice").text(res)
      $(".admin").show()
      super
      @stat.text "Admin on"

  logon_off = new LogonOff "log"
  logon_off.listen()
  adm_switch = new AdmSwitch "admin"
  adm_switch.listen()
