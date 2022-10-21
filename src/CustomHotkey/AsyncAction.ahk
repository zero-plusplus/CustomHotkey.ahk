class AsyncAction extends CustomHotkey.ActionBase {
  static defaultOptions := { async: ""
                           , delay: "0ms"
                           , action: "" }
  /**
   * @static
   * @param {string} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && ObjHasKey(data, "async")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.AsyncAction.defaultOptions}
   */
  normalizeActionData(data) {
    data := this.setDefaultOptions(data)
    data.delay := CustomHotkey.Util.timeunit(data.delay, "ms")
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    CustomHotkey.Util.setTimeout(ObjBindMethod(CustomHotkey.Action, "execute", [ data.async, this ]), data.delay)
  }
}