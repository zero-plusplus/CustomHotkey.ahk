class MousePositionCondition extends CustomHotkey.ConditionBase {
  static edgeSize := 5
  static defaultOptions := { mousepos: "" }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return IsObject(data) && ObjHasKey(data, "mousepos")
  }
  /**
   * Execute the Condition.
   * @return {boolean}
   */
  call() {
    data := this.data
    edgeSize := CustomHotkey.MousePositionCondition.edgeSize

    rect := ""
    if (IsObject(data.mousepos)) {
      rect := new CustomHotkey.Util.Rect(data.mousepos)
    }
    else if (data.mousepos ~= "i)^window-") {
      rect := this._getRectInWindow(data.mousepos, edgeSize)
    }
    else {
      rect := this._getRectInMonitor(data.mousepos, edgeSize)
    }

    if (CustomHotkey.Util.isNonEmpty(rect)) {
      mousePosition := new CustomHotkey.Util.Coordinates(0, 0, "mouse")
      mouseRect := new CustomHotkey.Util.Rect(mousePosition, mousePosition)
      if (rect.contains(mouseRect)) {
        return true
      }
    }
    return false
  }
  /**
   * @private
   * @param {string} mousepos
   * @param {number} edgeSize
   * @return {CustomHotkey.Util.Rect}
   */
  _getRectInMonitor(mousepos, edgeSize) {
    target := ""

    regex := "i)^((screen|monitor)-)?((?<target>\d+|primary)-)?"
    match := CustomHotkey.Util.regExMatch(mousepos, regex)
    if (match && match.target) {
      target := match.target
    }

    mousepos := RegExReplace(mousepos, regex, "")
    monitorInfo := new CustomHotkey.Util.MonitorInfo(target)
    screenX := monitorInfo.rect.x
    screenY := monitorInfo.rect.y
    screenWidth := monitorInfo.rect.width
    screenHeight := monitorInfo.rect.height

    if (mousepos ~= "i)^top-left(-corner)?$") {
      rect := new CustomHotkey.Util.Rect(screenX, screenY, edgeSize, edgeSize)
    }
    else if (mousepos ~= "i)^top(-edge)?$") {
      rect := new CustomHotkey.Util.Rect(screenX, screenY, screenWidth - (edgeSize * 2), edgeSize)
    }
    else if (mousepos ~= "i)^top-right(-corner)?$") {
      rect := new CustomHotkey.Util.Rect(screenX + (screenWidth - edgeSize), screenY, screenWidth, edgeSize)
    }
    else if (mousepos ~= "i)^left(-edge)?$") {
      rect := new CustomHotkey.Util.Rect(screenX, screenY + edgeSize, edgeSize, screenHeight - (edgeSize * 2))
    }
    else if (mousepos ~= "i)^right(-edge)?$") {
      rect := new CustomHotkey.Util.Rect(screenWidth - edgeSize, screenY, edgeSize, screenHeight - (edgeSize * 2))
    }
    else if (mousepos ~= "i)^bottom-left(-corner)?$") {
      rect := new CustomHotkey.Util.Rect(screenX, screenY + (screenHeight - edgeSize), edgeSize, edgeSize)
    }
    else if (mousepos ~= "i)^bottom(-edge)?$") {
      rect := new CustomHotkey.Util.Rect(screenX + edgeSize, screenY + (screenHeight - edgeSize), screenWidth - (edgeSize * 2), edgeSize)
    }
    else if (mousepos ~= "i)^bottom-right(-corner)?$") {
      rect := new CustomHotkey.Util.Rect(screenX + (screenWidth - edgeSize), screenY + (screenHeight - edgeSize), edgeSize, edgeSize)
    }
    return rect
  }
  /**
   * @private
   * @return {CustomHotkey.Util.Rect}
   */
  _getRectInWindow() {
    pos1 := new CustomHotkey.Util.Coordinates(0, 0, "window-top-left")
    pos2 := new CustomHotkey.Util.Coordinates(0, 0, "window-bottom-right")
    rect := new CustomHotkey.Util.Rect([ pos1, pos2 ])
    return rect
  }
}