class ImageCondition extends CustomHotkey.ConditionBase {
  static defaultOptions := { image: ""
                           , targetRect: "window" }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return IsObject(data) && ObjHasKey(data, "image")
  }
  /**
   * Execute the Condition.
   * @return {boolean}
   */
  call() {
    data := this.data

    pos := CustomHotkey.Util.searchImage(data.image, data.targetRect)
    return CustomHotkey.Util.toBoolean(pos)
  }
}