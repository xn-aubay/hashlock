# Main script for Firefox

Widget = require("sdk/widget").Widget
Panel = require("sdk/panel").Panel
data = require("sdk/self").data
PageMod = require("sdk/page-mod").PageMod
tabs = require("sdk/tabs")
HashLockFirefoxWorker = require("./worker/firefox").HashLockFirefoxWorker

config_panel = null
page_mod = null
widget = null
worker = null

exports.main = ->

  # Main add-on worker
  worker = new HashLockFirefoxWorker()

  # Config panel (popup)
  config_panel = Panel(
    width: 500,
    height: 350,
    contentURL: data.url('popup.html'),
    contentScriptFile: [
      data.url("jquery-2.1.0.min.js"),
      data.url("content-script/common.js"),
      data.url("content-script/firefox.js")
    ]
  )
  worker.addPeer config_panel.port, true

  # Widget (icon)
  widget = new Widget(
    id: "hashlock-widget",
    label: "HashLock",
    contentURL: data.url("images/hashlock.png"),
    panel: config_panel
  )

  # Page content script (peer on each tab)
  page_mod = PageMod(
    include: "*",
    contentScriptFile: [
      data.url("jquery-2.1.0.min.js"),
      data.url("content-script/common.js"),
      data.url("content-script/firefox.js")
    ],
    onAttach: (page_worker) ->
      worker.addPeer page_worker.port
      page_worker.on 'detach', ->
        worker.removePeer page_worker.port
  )
