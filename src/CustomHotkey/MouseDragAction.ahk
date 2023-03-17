class MouseDragAction extends CustomHotkey.ActionBase {
  static defaultOptions := { button: "LButton"
                           , from: { x: 0, y: 0, origin: "mouse" }
                           , to: { x: 0, y: 0, origin: "mouse" }
                           , mode: "Event"
                           , speed: "" }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && ObjHasKey(data, "to")
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    start := new CustomHotkey.Util.Coordinates(0, 0, "mouse")
    from := new CustomHotkey.Util.Coordinates(data.from.x, data.from.y, data.from.origin)
    to := new CustomHotkey.Util.Coordinates(data.to.x, data.to.y, data.to.origin)

    button := StrSplit(data.button, " ")[1] ; "LButton Up" => "LButton"
    this.executeAction({ button: button . " Down"
                       , x: from.x
                       , y: from.y
                       , origin: "monitors"
                       , mode: data.mode
                       , speed: data.speed })
    this.executeAction({ button: button . " Up"
                       , x: to.x
                       , y: to.y
                       , origin: "monitors"
                       , mode: data.mode
                       , speed: data.speed })
    if (CustomHotkey.Util.isNonEmpty(data.restore) || data.restore == 0) {
      speed := data.speed ? data.speed : 0
      if (data.restore < 0) {
        speed := Abs(data.restore)
      }
      this.executeAction({ x: start.x, y: start.y, origin: "monitors", speed: speed})
    }
  }
}