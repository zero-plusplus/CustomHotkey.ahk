/**
 * @author zero-plusplus (https://github.com/zero-plusplus)
 * @repository https://github.com/zero-plusplus/CustomHotkey.ahk
 * @license MIT
 */
#UseHook On
#InstallKeybdHook
#InstallMouseHook
class CustomHotkey extends CustomHotkey.Util.Functor {
  static debugMode := false
  static debugOptions := { enableActionLog: true, enableConditionLog: false }
  static logger := new CustomHotkey.Util.DebugLogger()
  /**
   * Group of all registered hotkeys.
   */
  static registeredHotkeys := new CustomHotkey.Group()
  static enabledAllHotkey := true
  static enabledSingleKeyHotkey := true
  /**
   * A single key, such as `a` or `b`, is a group of hotkeys.
   *
   * These hotkeys may cause some Actions that accept keystrokes to not work properly.
   * This field is provided to manage that hotkey to avoid that and to temporarily disable it in the Action.
   */
  static registeredSingleKeyHotkeys := new CustomHotkey.Group()
  /**
   * @type {Array<{ triggered: callable; executed: callable }>}
   */
  hooks := { execution: "", executed: "" }
  /**
   * @param {string | string[]} trigger
   * @param {any | CustomHotkey.ActionBase} action
   * @param {any | CustomHotkey.ConditionBase} condition
   * @param {{ execution: callable; executed: callable; }} hooks
   */
  __NEW(trigger, action, condition := "", hooks := "") {
    triggerAndOptions := StrSplit(trigger, "|")
    rawTrigger := CustomHotkey.CustomLabel.replace(triggerAndOptions[1])
    rawOptions := trigerAndOptions[2]

    this.trigger := new CustomHotkey.Trigger(rawTrigger)
    CustomHotkey.registeredHotkeys.add(this)
    if (this.trigger.isSingleKey) {
      CustomHotkey.registeredSingleKeyHotkeys.add(this)
    }

    this.setOptions(rawOptions)
    this.setHook(hooks)
    this.rawAction := action
    this.action := new CustomHotkey.Action(action, this)
    this.condition := ""
    if (CustomHotkey.Util.isNonEmpty(condition)) {
      this.rawCondition := condition
      this.condition := new CustomHotkey.Condition(condition, this.trigger.isSingleKey)
    }
    this.isRegistered := false
    this.enabled := false
    this.priority := 0
  }
  /**
   * Disable interrupts for other hotkeys.
   * It also returns a callable object to return the state.
   * @static
   * @return {callable}
   */
  threadNoHotkeys(_stores := "") {
    restoreMode := CustomHotkey.Util.isNonEmpty(_stores)
    if (restoreMode) {
      for hk, priority in _stores {
        if (CustomHotkey.Util.isNonEmpty(priority)) {
          hk.setPriority(priority)
        }
      }
      return
    }

    trigger := new CustomHotkey.Trigger(A_ThisHotkey)

    _stores := _stores ? _stores : {}
    for i, hk in CustomHotkey.registeredHotkeys {
      if (trigger.equals(hk.trigger)) {
        continue
      }
      _stores[hk] := hk.priority
      hk.setPriority(-2147483648)
    }
    return ObjBindMethod(this, "threadNoHotkeys", _stores)
  }
  /**
   * Execute registerd Action.
   */
  call(params*) {
    dataFromExecuting := CustomHotkey.Util.invoke(this.hooks.execution)
    result := CustomHotkey.Util.invoke(this.action, params*)
    CustomHotkey.Util.invoke(this.hooks.executed, dataFromExecuting)
    return result
  }
  /**
   * Register a hotkey.
   * @chainable
   */
  register() {
    this.isRegistered := true

    Hotkey, If
    if (this.condition) {
      condition := this.condition
      Hotkey, If, %condition%
    }
    Hotkey, % this.trigger.raw, %this%, % this.getOptions()
    Hotkey, If

    return this
  }
  /**
   * Return a string representation of the options.
   * @return {string}
   */
  getOptions() {
    options := ""
    if (this.enableBuffer == true || this.enableBuffer == false) {
      options .= Format("B{}", this.enableBuffer)
    }
    if (this.priority != "") {
      options .= Format("P{}", this.priority)
    }
    if (this.maxThreads != "") {
      options .= Format("T{}", this.maxThreads)
    }
    if (this.inputLevel != "") {
      options .= Format("I{}", this.inputLevel)
    }
    return options
  }
  /**
   * Register hooks to be called before and after the action is executed.
   * @param {{ execution: callable; executed: callable; }} hooks
   * @chainable
   */
  /**
   * @param {"execution" | "executed"} eventName
   * @param {callable} callable
   * @chainable
   */
  setHook(params*) {
    if (params.length() == 1) {
      if (IsObject(params[1])) {
        this.hooks := params[1]
      }
      return this
    }

    this.hooks[params[1]] := params[2]
    return this
  }
  /**
   * Enable/Disable the hotkey buffer.
   * @param {boolean} enabled
   * @chainable
   */
  setEnableBuffer(state) {
    this.enableBuffer := state
    this.updateOptions()
    return this
  }
  /**
   * Set a priority of the hotkey thread.
   * @param {number} priority
   * @chainable
   */
  setPriority(priority) {
    this.priority := priority
    this.updateOptions()
    return this
  }
  /**
   * Set a maximum number of hotkey threads.
   * @param {number} max
   * @chainable
   */
  setMaxThreads(max) {
    this.maxThreads := max
    this.updateOptions()
    return this
  }
  /**
   * Change a input level of the hotkey.
   * @param {number} level
   * @chainable
   */
  setInputLevel(level) {
    this.inputLevel := level
    this.updateOptions()
    return this
  }
  /**
   * Change a input level of the hotkey.
   * @param {boolean} [enabled := true]
   * @chainable
   */
  setFreeze(enabled := true) {
    this.freeze := enabled

    ; Maximize priority to ensure interruptions
    this.setPriority(2147483648)
    return this
  }
  /**
   * @chainable
   */
  updateOptions() {
    if (!this.isRegistered) {
      return this
    }
    return this.setState(this.enabled)
  }
  /**
   * Change hotkey status.
   * @param {boolean | "On" | "Off" | "Toggle" | -1}
   * @chainable
   */
  setState(state) {
    static stateMap := { 1: "On", 0: "Off", -1: "Toggle" }

    if (!this.isRegistered) {
      this.register()
    }
    if (this.freeze) {
      return this
    }

    if (ObjHasKey(stateMap, state)) {
      state := stateMap[state]
    }

    Hotkey, If
    if (this.condition) {
      condition := this.condition
      Hotkey, If, %condition%
    }

    Hotkey, % this.trigger.raw, %state%, % this.getOptions()
    Hotkey, If

    if (state ~= "i)^On$") {
      this.enabled := true
    }
    else if (state ~= "i)^Off$") {
      this.enabled := false
    }
    else if (state ~= "i)^Toggle$") {
      this.enabled := !this.enabled
    }
    return this
  }
  /**
   * Enable the hotkey.
   * @chainable
   */
  on() {
    return this.setState("On")
  }
  /**
   * Disable the hotkey.
   * @chainable
   */
  off() {
    return this.setState("Off")
  }
  /**
   * Toggle on/off the hotkey.
   * @chainable
   */
  toggle() {
    return this.setState("Toggle")
  }
  /**
   * Revert a state of the hotkey.
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
    optionDefinitionMap := { "B": { name: "setEnableBuffer", type: "boolean" }
                           , "F": { name: "setFreeze", type: "boolean" }
                           , "T": { name: "setMaxThreads", type: "number" }
                           , "I": { name: "setInputLevel", type: "number" }
                           , "P": { name: "setPriority", type: "number" } }
    options := CustomHotkey.Util.parseOptionsString(options, optionDefinitionMap)
    for name, value in options {
      ObjBindMethod(this, name).call(value)
    }
    return this
  }

  #Include %A_LineFile%\..\CustomHotkey\Action.ahk
  #Include %A_LineFile%\..\CustomHotkey\ActionBase.ahk
  #Include %A_LineFile%\..\CustomHotkey\ActionDone.ahk
  #Include %A_LineFile%\..\CustomHotkey\AndCondition.ahk
  #Include %A_LineFile%\..\CustomHotkey\AsyncAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\CommandPaletteCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\Condition.ahk
  #Include %A_LineFile%\..\CustomHotkey\ConditionBase.ahk
  #Include %A_LineFile%\..\CustomHotkey\ConditionCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ContextMenuCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\CustomAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\CustomActions.ahk
  #Include %A_LineFile%\..\CustomHotkey\CustomCondition.ahk
  #Include %A_LineFile%\..\CustomHotkey\CustomLabel.ahk
  #Include %A_LineFile%\..\CustomHotkey\DelayAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\DropperAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ExitAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ExitAllAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ExtraPressCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\Group.ahk
  #Include %A_LineFile%\..\CustomHotkey\HoldEventCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ImageClickAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ImageCondition.ahk
  #Include %A_LineFile%\..\CustomHotkey\ImeAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ImeCondition.ahk
  #Include %A_LineFile%\..\CustomHotkey\KeyStrokeCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ModifierPressCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\MouseClickAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\MouseDragAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\MouseGestureCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\MouseMoveAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\MouseTimeIdleCondition.ahk
  #Include %A_LineFile%\..\CustomHotkey\OrCondition.ahk
  #Include %A_LineFile%\..\CustomHotkey\PasteAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\PressEventCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ReloadAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\Remap.ahk
  #Include %A_LineFile%\..\CustomHotkey\RunAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\SendAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\Template.ahk
  #Include %A_LineFile%\..\CustomHotkey\TernaryCombiAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\ToolTipAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\TrayTipAction.ahk
  #Include %A_LineFile%\..\CustomHotkey\Trigger.ahk
  #Include %A_LineFile%\..\CustomHotkey\Util.ahk
  #Include %A_LineFile%\..\CustomHotkey\WindowCondition.ahk
}