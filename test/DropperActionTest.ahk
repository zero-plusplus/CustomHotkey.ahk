#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & Up", { dropper: "color" }).on()
new CustomHotkey("RCtrl & Down", { dropper: "color", options: { template: "R: {R}, G: {G}, B: {B}", method: "Slow" } }).on()
new CustomHotkey("RCtrl & Left", { dropper: "coordinates" }).on()
new CustomHotkey("RCtrl & Right", { dropper: "coord", options: "x: {x}`ny: {y}" }).on()
new CustomHotkey("RCtrl & 0", { dropper: "coordinates", options: { origin: "window" } }).on()
new CustomHotkey("RCtrl & 9", { dropper: "window" }).on()
new CustomHotkey("RCtrl & 8", { dropper: Func("CustomTarget"), options: { template: "{}, {}" } }).on()
CustomTarget(position, options) {
  return CustomHotkey.Util.templateString(options.template, position.x, position.y)
}

new CustomHotkey("RCtrl & 1", [ { key: "q", desc: "color", action: { dropper: "color" } }
                              , { key: "w", desc: "coordinates", action: { dropper: "coordinates" } }
                              , { key: "e", desc: "window", action: { dropper: "window" } } ]).on()
