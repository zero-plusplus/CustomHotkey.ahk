class Remap extends CustomHotkey.Util.Functor {
  /**
   * All labels in the modifier key.
   * @type {string[]}
   */
  static modifiers := [ "Shift", "LShift", "RShift", "Control", "LControl", "RControl", "Ctrl", "LCtrl", "RCtrl", "Alt", "LAlt", "RAlt", "LWin", "RWin" ]
  /**
   * All labels in the mouse button.
   * @type {string[]}
   */
  static mouseButtons := [ "LButton", "RButton", "MButton", "XButton1", "XButton2", "WheelUp", "WheelDown", "WheelLeft", "WheelRight" ]
  /**
   * @type {CustomHotkey.Template}
   */
  hotkeys := ""
  /**
   * @param {string} originalKey
   * @param {string} replacedKey
   * @param {any} condition
   */
  __NEW(originalKey, replacedKey, condition := "") {
    triggerAndOptions := StrSplit(originalKey, "|")
    key := CustomHotkey.CustomLabel.replace(triggerAndOptions[1])
    rawOptions := triggerAndOptions[2]

    onKeydown := ObjBindMethod(CustomHotkey.Remap, "_simulateKeyPress", "{Blind}{" . replacedKey . " DownR}")
    onKeyup := ObjBindMethod(CustomHotkey.Remap, "_simulateKeyPress", "{Blind}{" . replacedKey . " Up}")
    if (CustomHotkey.Util.includesArrayIgnoreCase(this.modifiers, key) && CustomHotkey.Util.includesArrayIgnoreCase(this.modifiers, replacedKey)) {
      onKeydown := ObjBindMethod(CustomHotkey.Remap, "_simulateKeyPress", "{Blind}{" key " Up}{" . replacedKey . " DownR}")
    }
    this.hotkeys := new CustomHotkey.Group()
    this.hotkeys.add("*" . key . "|" . rawOptions, onKeydown, condition)
    this.hotkeys.add("*" . key . " up|" . rawOptions, onKeyup, condition)

    this.priority := 0
  }
  /**
   * Execute registerd remap Action.
   */
  call() {
    for i, hk in this.hotkeys {
      %hk%()
    }
  }
  /**
   * Register a remap.
   * @chainable
   */
  register() {
    for i, hk in this.hotkeys {
      hk.register()
    }
    return this
  }
  /**
   * Return a string representation of the options.
   * @return {string}
   */
  getOptions() {
    return this.hotkeys[1].getOptions()
  }
  /**
   * Enable/Disable the hotkey buffer.
   * @param {boolean} enabled
   * @chainable
   */
  setEnableBuffer(state) {
    for i, hk in this.hotkeys {
      hk.setEnableBuffer(state)
    }
    return this
  }
  /**
   * Change a priority of the hotkey thread.
   * @param {number} priority
   * @chainable
   */
  setPriority(priority) {
    this.priority := priority
    for i, hk in this.hotkeys {
      hk.setPriority(priority)
    }
    return this
  }
  /**
   * Set a maximum number of hotkey threads.
   * @param {number} max
   * @chainable
   */
  setMaxThreads(max) {
    this.maxThreads := max
    for i, hk in this.hotkeys {
      hk.setMaxThreads(max)
    }
    return this
  }
  /**
   * Change a input level of the hotkey.
   * @param {number} level
   * @chainable
   */
  setInputLevel(level) {
    this.inputLevel := level
    for i, hk in this.hotkeys {
      hk.setInputLevel(level)
    }
    return this
  }
  /**
   * Change a input level of the hotkey.
   * @param {boolean} [enabled := true]
   * @chainable
   */
  setFreeze(enabled := true) {
    this.freeze := enabled
    for i, hk in this.hotkeys {
      hk.setFreeze(enabled)
    }
    return this
  }
  /**
   * Change a remap status.
   * @param {boolean | "On" | "Off" | "Toggle" | -1}
   * @chainable
   */
  setState(state) {
    this.prevEnabled := this.hotkeys[1].enabled
    for i, hk in this.hotkeys {
      hk.setState(state)
    }
    this.enabled := this.hotkeys[1].enabled
    return this
  }
  /**
   * Enable a remap.
   * @chainable
   */
  on() {
    return this.setState("On")
  }
  /**
   * Disable a remap.
   * @chainable
   */
  off() {
    return this.setState("Off")
  }
  /**
   * Toggle on/off a remap.
   * @chainable
   */
  toggle() {
    return this.setState("Toggle")
  }
  /**
   * Revert a state of remap.
   * @chainable
   */
  revert() {
    return this.setState(this.prevEnabled)
  }
  /**
   * Set each setting at once using the string representation option.
   * @param {string} options
   * @chainable
   */
  setOptions(options) {
    for i, hk in this.hotkeys {
      hk.setOptions(options)
    }
    return this
  }
  /**
   * Simulate key remapping.
   * @private
   */
  _simulateKeyPress(keys) {
    SetKeyDelay, -1
    Send %keys%
  }
  /**
   * Simulate mouse button remapping.
   * @private
   */
  _simulateMouseButtonPress() {
    SetMouseDelay, -1
    if (!GetKeyState(this.action)) {
      Send % "{Blind}{" this.action " DownR}"
    }
  }
}