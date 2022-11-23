class ImageClickAction extends CustomHotkey.ActionBase {
  static defaultOptions := { image: ""
                           , button: "LButton"
                           , offset: { x: 0, y: 0 }
                           , targetRect: "window"
                           , mode: "Event"
                           , count: 1
                           , speed: ""
                           , restore: false }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && ObjHasKey(data, "image")
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    pos := CustomHotkey.Util.searchImage(data.image, data.targetRect)
    if (!pos) {
      return CustomHotkey.ActionDone
    }

    pos.x += data.offset.x
    pos.y += data.offset.y
    this.executeAction({ button: data.button
                       , mode: data.mode
                       , x: pos.x
                       , y: pos.y
                       , origin: "monitors"
                       , count: data.count
                       , speed: data.speed, restore: data.restore })
  }
}