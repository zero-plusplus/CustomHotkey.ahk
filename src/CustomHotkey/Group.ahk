class Group {
  isRegistered := false
  prevEnabledMap := ""
  enabled := false
  _items := []
  __GET(keys*) {
    if (CustomHotkey.Util.isNumber(keys[1])) {
      index := keys[1]
      items := ObjRawGet(this, "_items")
      item := items[index]
      return item
    }
  }
  _NewEnum() {
    return this._items._NewEnum()
  }
  /**
   * Return an object with the Trigger as key and the hotkey state as value.
   * @return {{ [key: string]: boolean }}
   */
  getCurrentStateMap() {
    stateMap := {}
    for i, hk in this {
      stateMap[hk.trigger.raw] := hk.enabled
    }
    return stateMap
  }
  /**
   * @param {string | string[]} trigger
   * @param {callable} action
   * @param {callable} [condition]
   * @chainable
   */
  /**
   * @param {CustomHotkey} hotkeyRegister
   * @param {callable} [condition]
   * @chainable
   */
  /**
   * @param {{ [key: string | string[]]: callable }} hotkeyMap
   * @param {callable} [condition]
   * @chainable
   */
  add(params*) {
    if (IsObject(params[1]) && !CustomHotkey.Util.isArray(params[1])) {
      ; [signature] add(hotkeyRegister: { register: () => this, on: () => this, off: () => this, toggle: () => this })
      if (CustomHotkey.Util.instanceOf(params[1], CustomHotkey) || CustomHotkey.Util.instanceOf(params[1], CustomHotkey.Group)) {
        this._items.push(params[1])
        return this
      }

      ; [signature] add(hotkeys: { [key: HotkeyTrigger]: action: HotkeyAction }, condition?)
      hotkeyMap := params[1]
      condition := params[2]
      for trigger, action in hotkeyMap {
        this.add(trigger, action, condition)
      }
      return this
    }

    ; [signature] add(trigger: HotkeyTrigger, action: HotkeyAction)
    triggers := CustomHotkey.Util.isArray(params[1]) ? params[1] : [ params[1] ]
    action := params[2]
    condition := params[3]
    for i, trigger in triggers {
      this._items.push(new CustomHotkey(trigger, action, condition))
    }
    return this
  }
  /**
   * Register a hotkeys in the group.
   * @chainable
   */
  register() {
    for i, hk in this {
      hk.register()
    }
    this.isRegistered := true
    return this
  }
  /**
   * @param {boolean | "On" | "Off" | "Toggle" | -1}
   */
  setState(state) {
    if (!this.isRegistered) {
      this.register()
    }

    for i, hk in this {
      this.prevEnabledMap[hk.trigger.raw] := hk.enabled
      hk.setState(state)
    }

    if (state ~= "i)^1|On$") {
      this.enabled := true
    }
    else if (state ~= "i)^0|Off$") {
      this.enabled := false
    }
    else if (state ~= "i)^-1|Toggle$") {
      this.enabled := !this.enabled
    }
    return this
  }
  /**
   * Enable all hotkeys in the group.
   * @chainable
   */
  on() {
    return this.setState("On")
  }
  /**
   * Disable all hotkeys in the group.
   * @chainable
   */
  off() {
    return this.setState("Off")
  }
  /**
   * Toggle on/off a hotkeys in the group.
   */
  toggle() {
    return this.setState("Togle")
  }
  /**
   * Turn off all hotkey states and returns a callable object that restores them.
   * @return {callable}
   */
  tempOff() {
    if (CustomHotkey.Util.isEmpty(this.prevEnabledMap)) {
      this.prevEnabledMap := this.getCurrentStateMap()
      this.off()
    }
    return ObjBindMethod(this, "revert", prevEnabledMap)
  }
  /**
   * Revert the state of group.
   * @chainable
   */
  revert(stateMap := "") {
    stateMap := stateMap ? stateMap : this.prevEnabledMap
    for i, hk in this {
      hk.setState(stateMap[hk.trigger.raw])
    }
    this.prevEnabledMap := ""
    return this
  }
}