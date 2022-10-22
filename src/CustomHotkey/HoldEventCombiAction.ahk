class HoldEventCombiAction extends CustomHotkey.ActionBase {
  static defaultOptions := { tap: ""
                           , holding: ""
                           , hold: ""
                           , release: ""
                           , targetKey: ""
                           , nodelay: false
                           , repeatInterval: false
                           , timeout_tap: 100 }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && (ObjHasKey(data, "tap") || ObjHasKey(data, "hold"))
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.PressEventCombiAction.defaultOptions}
   */
  normalizeActionData(data) {
    normalized := {}
    normalized_highpriority := {}
    for name, value in data {
      match := CustomHotkey.Util.regexMatch(name, "i)(?<type>tap|hold)\|(?<options>[^\r\n]*)")
      if (!match) {
        normalized[name] := value
        continue
      }

      type := match.type
      rawOptions := match.options
      if (type ~= "i)^tap") {
        optionDefinitionMap := { "T": { name: "timeout_tap", type: "time" }
                               , "N": { name: "nodelay", type: "boolean" } }
        options := CustomHotkey.Util.parseOptionsString(rawOptions, optionDefinitionMap)
        normalized_highpriority[type] := value
        normalized_highpriority.timeout_tap := options.timeout_tap
        normalized_highpriority.timeout_tap := options.nodelay
        continue
      }
      if (type ~= "i)^hold") {
        optionDefinitionMap := { "R": { name: "repeatInterval", type: "time" } }
        options := CustomHotkey.Util.parseOptionsString(rawOptions, optionDefinitionMap)
        normalized_highpriority[type] := value
        normalized_highpriority.repeatInterval := options.repeatInterval
      }
    }
    for name, value in normalized_highpriority {
      normalized[name] := value
    }

    if (!normalized.holding) {
      normalized.holding := ObjBindMethod(this, "onHolding")
    }

    if (CustomHotkey.Util.instanceOf(this.prevAction, CustomHotkey.KeyStrokeCombiAction)) {
      data.targetKey := new CustomHotkey.Trigger(this.prevAction.context.input)
    }

    normalized := this.setDefaultOptions(normalized)
    return normalized
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    CustomHotkey.Util.blockUserInput()

    trigger := new CustomHotkey.Trigger(A_ThisHotkey)
    if (data.targetKey != "") {
      trigger := new CustomHotkey.Trigger(data.targetKey)
    }

    startTime_ms := A_TickCount
    executedHoldAction := false

    isDone := false
    holdResult := this.executeAction(data.holding)
    while (trigger.pressing) {
      elapsedTime_ms := A_TickCount - startTime_ms
      if (data.tap != "" && elapsedTime_ms <= data.timeout_tap) {
        continue
      }
      if (CustomHotkey.Util.blockUserInput.forceTerminated) {
        isDone := true
        break
      }

      if (executedHoldAction) {
        if (data.repeatInterval == 0) {
          Sleep 16.666
          continue
        }
        Sleep, % data.repeatInterval
      }

      result := this.executeAction(data.hold, holdResult, CustomHotkey.ActionDone)
      executedHoldAction := true
      if (result == CustomHotkey.ActionDone) {
        isDone := true
        break
      }
      holdResult := result
    }

    if (executedHoldAction) {
      this.executeAction(data.release, holdResult, isDone)
    }
    else if (data.tap) {
      this.executeAction(data.tap)
    }

    CustomHotkey.Util.blockUserInput(false)
  }
  /**
   * @event
   */
  onHolding() {
  }
  /**
   * @event
   */
  onExecuting() {
    threadNoHotkeysRestorer := CustomHotkey.threadNoHotkeys()
    return threadNoHotkeysRestorer
  }
  /**
   * @event
   */
  onExecuted(threadNoHotkeysRestorer) {
    new CustomHotkey.Trigger(A_ThisHotkey).releaseAll()
    CustomHotkey.Util.releaseModifiers()
    %threadNoHotkeysRestorer%()
  }
}