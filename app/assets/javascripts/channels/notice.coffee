App.cable.status = {}
App.cable.status.set_connected = ->
  $('#notice-channel-status').removeClass('text-danger')
    .removeClass('text-muted').addClass('text-success')

App.cable.status.set_disconnected = ->
  $('#notice-channel-status').removeClass('text-success')
    .removeClass('text-muted').addClass('text-danger')

App.cable.status.update = ->
  if App.cable.connection.isActive()
  then App.cable.status.set_connected()
  else App.cable.status.set_disconnected()

class App.NoticeChannel
  constructor: ->
    $('#notice-channel-status').show()
    App.cable.status.update()
    @channel = App.cable.subscriptions.create "NoticeChannel",
      # Called when the subscription is ready for use on the server
      connected: ->
        App.cable.status.set_connected()

      # Called when the subscription has been terminated by the server
      disconnected: ->
        App.cable.status.set_disconnected()

      # Called when there's incoming data on the websocket for this channel
      received: (data) ->
        $("#word-added-notice").text(data.word)

document.addEventListener 'turbolinks:load', ->
  App.cable.status.update()
