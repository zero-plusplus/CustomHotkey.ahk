class ExtraPressCombiAction extends CustomHotkey.ActionBase {
  static defaultOptions := { release: ""
                           , keyRepeat: "15ms" }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && !CustomHotkey.Util.isArray(data)
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ExtraPressCombiAction.defaultOptions}
   */
  normalizeActionData(data) {
    data := this.setDefaultOptions(data)

    normalized := {}
    normalized.release := data.delete("release")
    normalized.hint := data.delete("hint")
    normalized.keyRepeat := CustomHotkey.Util.timeunit(data.delete("keyRepeat"))

    normalized.items := []
    for key, action in data {
      match := CustomHotkey.Util.regExMatch(key, "(?<key>[^\r\n|]+)(\|(?<options>[^\r\n]*))?")
      if (!match) {
        continue
      }
      optionDefinitionMap := { "R": { name: "keyRepeat", type: "time", default: normalized.keyRepeat }}
      options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
      item := { key: match.key, options: options, action: action }

      normalized.items.push(item)
    }
    return normalized
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    CustomHotkey.Util.blockUserInput()
    hotkeyStateRevertor := CustomHotkey.registeredHotkeys.tempOff()

    trigger := new CustomHotkey.Trigger(A_ThisHotkey)
    isExecutedAction := false
    while (trigger.pressing) {
      if (GetKeyState("Escape", "P") || (GetKeyState("Ctrl", "P") && GetKeyState("Alt", "P") && GetKeyState("Delete", "P"))) {
        break
      }

      for i, item in data.items {
        key := item.key
        options := item.options
        action := item.action

        if (GetKeyState(key, "P")) {
          this.executeAction(action)
          isExecutedAction := true

          if (options.keyRepeat == false) {
            CustomHotkey.Util.waitReleaseKey(key)
            continue
          }

          coolTime_ms := 300
          startTime_ms := A_TickCount
          while (GetKeyState(key, "P")) {
            if (GetKeyState("Escape", "P") || (GetKeyState("Ctrl", "P") && GetKeyState("Alt", "P") && GetKeyState("Delete", "P"))) {
              break
            }

            elapsedTime_ms := A_TickCount - startTime_ms
            if (elapsedTime_ms < coolTime_ms) {
              continue
            }

            startTime_ms := A_TickCount
            coolTime_ms := CustomHotkey.Util.clampNumber(options.keyRepeat, 30, 150)
            this.executeAction(action)
            Sleep, %coolTime_ms%
          }
        }
      }
      Sleep, 16.666
    }

    if (!isExecutedAction && data.release) {
      this.executeAction(data.release)
    }

    CustomHotkey.Util.blockUserInput(false)
    %hotkeyStateRevertor%()
    trigger.releaseAll()
  }
}