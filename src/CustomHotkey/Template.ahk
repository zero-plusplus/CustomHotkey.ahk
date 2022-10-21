class Template extends CustomHotkey.Group {
  _isActivate := false
  isRegistered := false
  enabled := false
  context := { dataFromActivate: "" }
  /**
   * @param {callable} condition
   */
  __NEW(condition := "") {
    if (!ObjHasKey(this, "condition") || this.condition == "") {
      this.condition := condition
    }
  }
  /**
   * @param {string | string[]} trigger
   * @param {callable} action
   * @chainable
   */
  /**
   * @param {CustomHotkey} hotkeyRegister
   * @chainable
   */
  /**
   * @param {{ [key: string | string[]]: callable }} hotkeyMap
   * @chainable
   */
  add(params*) {
    hooks := { execution: ObjBindMethod(this, "emit", "onExecuting")
             , executed: ObjBindMethod(this, "emit", "onExecuted") }

    ; [signature] add(hotkeys: { [key: HotkeyTrigger]: action: HotkeyAction }, condition?)
    if (params.length() == 1 && IsObject(params[1])) {
      hotkeyMap := params[1]
      for trigger, action in hotkeyMap {
        action := action
        this._items.push(new CustomHotkey(trigger, action, this.condition, hooks))
      }
      return this
    }

    ; [signature] add(trigger: HotkeyTrigger, action: HotkeyAction)
    triggers := CustomHotkey.Util.isArray(params[1]) ? params[1] : [ params[1] ]
    action := params[2]
    for i, trigger in triggers {
      this._items.push(new CustomHotkey(trigger, action, this.condition, hooks))
    }
    return this
  }
  /**
   * @param {string | string[]} trigger
   * @param {string} action
   */
  addRemap(trigger, action) {
    this._items.push(new CustomHotkey.Remap(trigger, action, this.condition))
    return this
  }
  /**
   * @chainable
   */
  register() {
    if (CustomHotkey.Util.isCallable(this.onWindowActivate) || CustomHotkey.Util.isCallable(this.onWindowInactivate)) {
      CustomHotkey.Util.WindowChangeEvent.register(ObjBindMethod(this, "onWindowChanged"))
    }
    for i, item in this {
      item.register()
    }
    this.isRegistered := true
    return this
  }
  /**
   * @param {string} eventName
   * @param {any[]} [params*]
   * @return {any}
   */
  emit(eventName, params*) {
    event := this[eventName]

    ; For instance-based cases, a global function may be specified
    if (CustomHotkey.Util.isGlobalFunc(event)) {
      return %event%(params*)
    }
    return ObjBindMethod(this, eventName).call(params*)
  }
  /**
   * @event
   */
  onExecuting() {
  }
  /**
   * @event
   */
  onExecuted() {
  }
  /**
   * @event
   */
  onWindowActivate() {
  }
  /**
   * @event
   */
  onWindowInactivate() {
  }
  /**
   * @event
   */
  onWindowChanged() {
    if (CustomHotkey.Util.isEmptyField(this, "condition")) {
      return
    }

    bk := A_IsCritical
    Critical, On

    activeWinInfo := ""
    if (CustomHotkey.Util.isCallable(this.condition)) {
      activeWinInfo := new CustomHotkey.Util.WindowInfo("A")
      if (!this.condition(activeWinInfo)) {
        activeWinInfo := ""
      }
    }
    else {
      activeWinInfo := new CustomHotkey.Util.WindowInfo(this.condition)
    }

    if (!this._isActivate && activeWinInfo.hwnd) {
      this._isActivate := true
      this.context.dataFromActivate := this.emit("onWindowActivate", activeWinInfo)
      Critical, %bk%
      return
    }

    if (this._isActivate) {
      this.emit("onWindowInactivate", activeWinInfo, this.context.dataFromActivate)
      this.context := { dataFromActivate: "" }
      this._isActivate := false
    }
    Critical, %bk%
  }
}