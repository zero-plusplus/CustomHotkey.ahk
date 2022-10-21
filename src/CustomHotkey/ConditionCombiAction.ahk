class ConditionCombiAction extends CustomHotkey.ActionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return false
    }

    if (CustomHotkey.Util.isArray(data)) {
      data := { items: data }
    }
    if (CustomHotkey.Util.isEmptyField(data, "items")) {
      return false
    }

    for i, item in data.items {
      if (!ObjHasKey(item, "condition")) {
        return false
      }
    }
    return true
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.AsyncAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (CustomHotkey.Util.IsArray(data)) {
      data := { items: data }
    }
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    defaultAction := data.defaultAction
    for i, item in data.items {
      if (item.condition == false) {
        defaultAction := item.action
        continue
      }

      if (!CustomHotkey.Condition.execute(item.condition)) {
        continue
      }
      return this.executeAction(item.action)
    }

    if (defaultAction != "") {
      return this.executeAction(defaultAction)
    }
  }
}