class MouseClickAction extends CustomHotkey.ActionBase {
  static defaultOptions := { button: "LButton"
                           , mode: "Event"
                           , x: 0
                           , y: 0
                           , origin: "mouse"
                           , count: 1
                           , speed: ""
                           , restore: false }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && (ObjHasKey(data, "button") || ObjHasKey(data, "count"))
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data
    match := CustomHotkey.Util.regexMatch(data.button, "Oi)^(\w+)(?:\s+(up|down))?")
    if (!match) {
      return
    }

    currentPosition := new CustomHotkey.Util.Coordinates(0, 0, "mouse")
    position := new CustomHotkey.Util.Coordinates(data.x, data.y, data.origin)
    button := match[1]
    if (button ~= "i)^(LButton|R)$") {
      button := "Left"
    }
    else if (button ~= "i)^(RButton|R)$") {
      button := "Right"
    }
    else if (button ~= "i)^(MButton|M)$") {
      button := "Middle"
    }

    event := match[2]
    if (event ~= "i)^U$") {
      event := "Up"
    }
    else if (event ~= "i)^D$") {
      event := "Down"
    }

    x := position.x
    y := position.y
    speed := data.speed != "" ? data.speed : A_DefaultMouseSpeed
    this.executeAction({ x: x, y: y, speed: speed, origin: "monitors" })

    bk := A_CoordModeMouse
    CoordMode, Mouse, Screen
    Loop % data.count
    {
      keys := event ? Format("{Click {1} {2}}", button, event) : Format("{Click {1}}", button)
      this.executeAction({ send: keys, mode: data.mode })
    }
    CoordMode, Mouse, %bk%

    if (data.restore) {
      if (data.restore < 0) {
        restoreSpeed := Abs(data.restore)
        this.executeAction({ x: currentPosition.x, y: currentPosition.y, origin: "monitors", speed: restoreSpeed })
        return
      }
      this.executeAction({ x: currentPosition.x, y: currentPosition.y, origin: "monitors", speed: 0 })
    }
  }
}