table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "matches", "alsa_output.usb-Logitech_G_series_G435*" },
    },
  },
  apply_properties = {
    ["priority.session"] = 2000,
    ["node.pause-on-idle"] = false,
  },
})
