
class PressEventCombiAction extends CustomHotkey.ActionBase {
  static defaultOptions := { single: ""
                           , double: ""
                           , long: ""
                           , nodelay: false
                           , timeout_long: 185
                           , timeout_double: 125 }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && (ObjHasKey(data, "single") || ObjHasKey(data, "double") || ObjHasKey(data, "long") || ObjHasKey(data, "triple") || ObjHasKey(data, "quadruple") || ObjHasKey(data, "quadruple"))
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.PressEventCombiAction.defaultOptions}
   */
  normalizeActionData(data) {
    optionsRegex := "i)(?<type>long|double)\|(?<options>[^\r\n]*)"

    normalized := {}
    normalized_highpriority := {}
    for name, value in data {
      match := CustomHotkey.Util.regexMatch(name, optionsRegex)
      if (!match) {
        normalized_highpriority[name] := value
        continue
      }

      rawOptions := match.options
      optionDefinitionMap := { "T": { name: "time", type: "time" }
                             , "N": { name: "nodelay", type: "boolean" } }
      options := CustomHotkey.Util.parseOptionsString(rawOptions, optionDefinitionMap)

      type := match.type
      normalized[type] := value
      if (options.time != "") {
        normalized["timeout_" type] := options.time
      }
      if (type ~= "i)^double$" && options.nodelay) {
        normalized.nodelay := true
      }
    }

    for name, value in normalized_highpriority {
      normalized[name] := value
    }

    if (CustomHotkey.Util.instanceOf(this.prevAction, CustomHotkey.KeyStrokeCombiAction)) {
      normalized.targetKey := this.prevAction.context.input
    }
    normalized := this.setDefaultOptions(normalized)

    if (ObjHasKey(data, "triple") || ObjHasKey(data, "quadruple") || ObjHasKey(data, "quintuple")) {
      normalized := { timeout_long: normalized.timeout_long
                    , timeout_double: normalized.timeout_double
                    , targetKey: normalized.targetKey
                    , nodelay: normalized.nodelay
                    , single: normalized.single
                    , long: normalized.long
                    , double: { timeout_long: normalized.timeout_long
                              , timeout_double: normalized.timeout_double
                              , targetKey: normalized.targetKey
                              , nodelay: normalized.nodelay
                              , single: normalized.double
                              , double: { timeout_long: normalized.timeout_long
                                        , timeout_double: normalized.timeout_double
                                        , targetKey: normalized.targetKey
                                        , nodelay: normalized.nodelay
                                        , single: data.triple
                                        , double: { timeout_long: normalized.timeout_long
                                                  , timeout_double: normalized.timeout_double
                                                  , targetKey: normalized.targetKey
                                                  , nodelay: normalized.nodelay
                                                  , single: data.quadruple
                                                  , double: data.quintuple } } } }
    }
    return normalized
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    CustomHotkey.Util.blockUserInput(true)
    if (data.nodelay) {
      this.executeAction(data.single, this.prevAction)
    }

    trigger := new CustomHotkey.Trigger(A_ThisHotkey)
    if (CustomHotkey.Util.isNonEmptyField(data, "targetKey") || CustomHotkey.Util.isNonEmptyField(this, "prevAction.data.targetKey")) {
      targetKey := CustomHotkey.Util.isNonEmptyField(data, "targetKey") ? data.targetKey : this.prevAction.data.targetKey
      trigger := new CustomHotkey.Trigger(targetKey)
      this.context.hotkeyStateRestorer := CustomHotkey.registeredHotkeys.tempOff()
      CustomHotkey.Util.blockUserInput()
    }

    action := ""
    if (CustomHotkey.Util.isNonEmpty(data.long) && this._isLongPress(trigger.key, data.timeout_long)) {
      action := data.long
    }
    else if (CustomHotkey.Util.isNonEmpty(data.double)) {
      if (CustomHotkey.Util.isEmpty(data.long)) {
        trigger.waitRelease()
      }
      if (data.nodelay) {
        if (this._isDoublePress(trigger.key, data.timeout_double)) {
          action := data.double
        }
      }
      else {
        action := this._isDoublePress(trigger.key, data.timeout_double)
          ? data.double
          : data.single
      }
    }
    else if (data.single != "") {
      action := data.single
    }

    this.executeAction(action)
    trigger.waitRelease()
    CustomHotkey.Util.blockUserInput(false)
  }
  /**
   * Determine if the specified key is pressed and held.
   * @private
   * @param {string} key
   * @param {number} timeout_ms
   * @return {number}
   */
  _isLongPress(keyName, timeout_ms) {
    KeyWait, %keyName%, % "T" . (timeout_ms / 1000)
    return CustomHotkey.Util.toBoolean(ErrorLevel)
  }
  /**
   * Determine if it was key pressed within the specified time.
   * @private
   * @param {string} key
   * @param {number} timeout_ms
   * @return {number}
   */
  _isDoublePress(keyName, timeout_ms) {
    KeyWait, %keyName%, % "D T" . (timeout_ms / 1000)
    return !ErrorLevel
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
    if (CustomHotkey.Util.isNonEmptyField(this, "context.hotkeyStateRestorer")) {
      CustomHotkey.Util.invoke(this.context.hotkeyStateRestorer)
    }
  }
}