class KeyStrokeCombiAction extends CustomHotkey.ActionBase {
  static defaultOptions := { autoKeys: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
                                       , "q", "w", "e", "r", "t", "y", "u", "i", "o", "p"
                                       , "a", "s", "d", "f", "g", "h", "j", "k", "l"
                                       , "z", "x", "c", "v", "b", "n", "m" ]
                           , autoFunctionKeys: [ "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"
                                               , "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20", "F21", "F22", "F23", "F24" ]
                           , tip: { x: 0, y: 0, origin: "", id: "", limitDescriptionLength: 100 } }
  context := ""
  shouldRestore := true
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return false
    }

    if (!CustomHotkey.Util.isArray(data)) {
      data := data.items
    }

    if (!CustomHotkey.Util.isArray(data)) {
      return false
    }

    for i, item in data {
      if (ObjHasKey(item, "key") && ObjHasKey(item, "action")) {
        continue
      }
      return false
    }
    return true
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.KeyStrokeCombiAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (CustomHotkey.Util.isArray(data)) {
      data := { items: data }
    }
    data := this.setDefaultOptions(data)

    autoKeys := data.autoKeys.clone()
    autoFunctionKeys := data.autoFunctionKeys.clone()
    for i, item in data.items {
      item.description := item.description ? item.description : item.desc

      if (item.key == "$") {
        item.key := autoKeys.removeAt(1)
        continue
      }

      if (item.key == "F$") {
        item.key := autoFunctionKeys.removeAt(1)
        continue
      }

      keyCode := CustomHotkey.CustomLabel.getKeyCode(item.key)
      if (keyCode) {
        item.key := keyCode
      }
    }

    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    endKeys := this._createEndKeys(data.items)
    this.context := { input: ""
                    , trigger: new CustomHotkey.Trigger(A_ThisHotkey)
                    , tip: new CustomHotkey.Util.ToolTip(data.tip.id)
                    , hook: InputHook("L0", endKeys)
                    , hotkeyStateRevertor: CustomHotkey.registeredHotkeys.tempOff() }
    this.context.hook.visibleNonText := false
    this.context.hook.start()

    message := this.prevAction ? "[ ESC / BS ] : GO BACK`n-----------------`n" : "[ ESC / BS ] : EXIT`n----------------`n"
    for i, item in data.items {
      description := item.description
      if (description) {
        description := CustomHotkey.Util.truncateString(description, data.tip.limitDescriptionLength)
      }

      label := CustomHotkey.CustomLabels.getLabel(item.key)
      message .= "[ " . (label ? label : item.key) . " ]"
      if (description) {
        message .= ": " . description
      }
      message .= "`n"
    }
    this.context.tip.show(RTrim(message, "`n"), data.tip)

    CustomHotkey.Util.waitReleaseKey([ "Escape", "Backspace", "Delete" ])
    while (true) {
      if ((GetKeyState("Ctrl", "P") && GetKeyState("Alt", "P") && GetKeyState("Delete", "P"))) {
        break
      }
      if (GetKeyState("Escape", "P") || GetKeyState("Backspace", "P") || GetKeyState("Delete", "P")) {
        this.context.tip.close()
        this.context.hook.stop()
        if (!GetKeyState("Ctrl", "P")) {
          this.restoreAction()
        }
        return
      }

      inputKey := this.context.hook.endKey
      if (inputKey == "") {
        continue
      }
      this.context.input := inputKey

      action := this.getAction(inputKey)
      if (action) {
        this.context.tip.close()
        this.context.hook.stop()
        this.executeAction(action)
        return
      }

      Sleep, 16.666
    }

    this.context.tip.close()
    this.context.hook.stop()
  }
  /**
   * @param {string} key
   * @return {any}
   */
  getAction(key) {
    for i, item in this.data.items {
      if (CustomHotkey.Util.equalsIgnoreCase(item.key, key)) {
        return item.action
      }

      virtualKey := Format("vk{:X}", GetKeyVK(key))
      if (CustomHotkey.Util.equalsIgnoreCase(item.key, virtualKey)) {
        return item.action
      }

      scanCode := Format("sc{:X}", GetKeySC(key))
      if (CustomHotkey.Util.equalsIgnoreCase(item.key, scanCode)) {
        return item.action
      }

      if (CustomHotkey.Util.equalsIgnoreCase(item.key, virtualKey . scanCode)) {
        return item.action
      }
    }
  }
  /**
   * @private
   * @param {Array<{ key: string }>} items
   * @return {string}
   */
  _createEndKeys(items) {
    endKeys := ""
    for i, item in items {
      endKeys .= "{" . item.key . "}"
    }
    return endKeys
  }
  /**
   * @event
   */
  onExecuted() {
    this.context.tip.close()
    this.context.hook.stop()
    CustomHotkey.Util.invoke(this.context.hotkeyStateRevertor)
  }
}