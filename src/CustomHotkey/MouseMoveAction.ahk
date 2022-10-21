class MouseMoveAction extends CustomHotkey.ActionBase {
  static defaultOptions := { x: 0
                           , y: 0
                           , origin: "mouse"
                           , speed: "" }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data)
      && ( ObjHasKey(data, "x")
        || ObjHasKey(data, "y")
        || ObjHasKey(data, "origin")
        || ObjHasKey(data, "speed") )
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    position := new CustomHotkey.Util.Coordinates(data.x, data.y, data.origin)
    speed := data.speed != "" ? data.speed : A_DefaultMouseSpeed

    bk := A_CoordModeMouse
    CoordMode, Mouse, Screen
    MouseMove, % position.x, % position.y, %speed%
    CoordMode, Mouse, %bk%
  }
}