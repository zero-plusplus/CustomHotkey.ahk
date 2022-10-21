class ActionBase {
  static defaultOptions := {}
  shouldRestore := false
  /**
   * @param {any} data
   * @param {CustomHotkey.ActionBase} [prevAction]
   */
  __NEW(data, prevAction := "") {
    if (CustomHotkey.Util.instanceOf(data, this)) {
      return data
    }

    this.prevAction := prevAction
    this.data := this.normalizeActionData(data)
  }
  /**
   * @param {any} caller
   * @param {any[]} params*
   * @return {any}
   */
  __CALL(caller, params*) {
    if (caller == "" || IsObject(caller)) {
      ; Ignore the caller
      result := this.call(params*)
      return result
    }
  }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return false
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ActionBase.defaultOptions}
   */
  normalizeActionData(data) {
    return this.setDefaultOptions(data)
  }
  /**
   * @static
   * @param {any} data
   * @param {any} [optionName := "defaultOptions"]
   * @return {CustomHotkey.ActionBase.defaultOptions}
   */
  /**
   * @static
   * @param {any} data
   * @param {any} options
   * @return {CustomHotkey.ActionBase.defaultOptions}
   */
  setDefaultOptions(data, optionsOrOptionName := "defaultOptions") {
    defaultOptions := IsObject(optionsOrOptionName)
      ? optionsOrOptionName
      : CustomHotkey.Util.getGlobal(this.__CLASS . "." . optionsOrOptionName, {})

    if (CustomHotkey.Util.isEnumerable(data)) {
      data := CustomHotkey.Util.deepDefaultsObject(data, defaultOptions)
    }
    return data
  }
  /**
   * Execute the Action.
   * @param {any[]} params*
   * @return {any}
   */
  call(params*) {
  }
  /**
   * Call an Action linked to the Action Data.
   * @param {any} data
   * @param {any[]} params*
   * @return {any}
   */
  executeAction(data, params*) {
    action := CustomHotkey.Action.create(data, this)
    result := CustomHotkey.Action.execute(action, params*)
    return result
  }
  /**
   * Try to restore previous Action.
   */
  restoreAction() {
    prevAction := this.prevAction
    while (CustomHotkey.Util.instanceof(prevAction, CustomHotkey.ActionBase)) {
      if (prevAction.shouldRestore) {
        CustomHotkey.Action.execute(prevAction)
        return
      }
      prevAction := prevAction.prevAction
    }
  }
  /**
   * Call before the Action is executed.
   * @event
   */
  onExecuting() {
  }
  /**
   * Call after the Action is executed.
   * @event
   */
  onExecuted() {
  }
}