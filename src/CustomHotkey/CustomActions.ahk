class CustomActions extends CustomHotkey.ActionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return CustomHotkey.Util.isArray(data)
  }
  /**
   * Execute the Action.
   */
  call() {
    actions := this.data

    currentData := ""
    for i, action in actions {
      newData := CustomHotkey.Util.isCallable(action)
        ? CustomHotkey.Util.invoke(action, currentData, CustomHotkey.ActionDone)
        : CustomHotkey.Action.execute(action, currentData, CustomHotkey.ActionDone)
      if (newData == CustomHotkey.ActionDone) {
        return
      }
      if (newData != "") {
        currentData := newData
      }
    }
  }
}