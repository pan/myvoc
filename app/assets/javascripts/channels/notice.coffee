App.notice = App.cable.subscriptions.create "NoticeChannel",
  # Called when the subscription is ready for use on the server
  connected: ->

  # Called when the subscription has been terminated by the server
  disconnected: ->

  # Called when there's incoming data on the websocket for this channel
  received: (data) ->
    $("#word-added-notice").text(data.word)
