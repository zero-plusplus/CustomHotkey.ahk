class SendAction extends CustomHotkey.ActionBase {
  static defaultOptions := { send: ""
                           , mode: "Event"
                           , ime: ""
                           , sendLevel: ""
                           , keyDelay: ""
                           , pressDuration: ""
                           , limitLength: 50
                           , allowMultiline: false }
  static prefixRegex := "i)^(?<prefix>{(?<mode>(Event|Input|Play|InputThenPlay)+)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {string} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return true
    }
    return IsObject(data) && ObjHasKey(data, "send")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.SendAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.SendAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.setDefaultOptions({ send: data })
      }

      data := { send: RegExReplace(data, prefixRegex, "") }
      data.mode := match.mode
      if (match.options != "") {
        optionDefinitionMap := { "I": { name: "ime", type: "time" }
                               , "S": { name: "sendLevel", type: "number" }
                               , "D": { name: "delay", type: "number" }
                               , "P": { name: "pressDuration", type: "number" }
                               , "L": { name: "limitLength", type: "number" }
                               , "M": { name: "allowMultiline", type: "boolean" } }
        options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
        data := this.setDefaultOptions(data, options)
      }
    }

    data := this.setDefaultOptions(data)
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    keys := data.send
    if (InStr(keys, "{SuffixKey}", false)) {
      keys := CustomHotkey.Util.replaceIgnoreCaseString(keys, "{SuffixKey}", "{" . new CustomHotkey.Trigger(A_ThisHotkey).suffixKey . "}")
    }
    else if (InStr(keys, "{SelectedText}", false)) {
      keys := CustomHotkey.Util.replaceIgnoreCaseString(keys, "{SelectedText}", CustomHotkey.Util.getSelectedText())
    }
    else if (InStr(keys, "{Clipboard}", false)) {
      keys := CustomHotkey.Util.replaceIgnoreCaseString(keys, "{Clipboard}", Clipboard)
    }
    if (!data.allowMultiline) {
      linebreakIndex := keys ~= "i)\r\n|\n"
      if (0 < linebreakIndex) {
        keys := SubStr(keys, 1, linebreakIndex - 1)
      }
    }

    restoreDelay_ms := ""
    if (!(data.ime == true || data.ime == false)) {
      restoreDelay_ms := data.ime
    }

    ime := data.ime
    if (restoreDelay_ms && 2 <= restoreDelay_ms) {
      ime := true
    }
    else if (restoreDelay_ms && restoreDelay_ms <= -1) {
      ime := false
    }

    restoreIme := -1
    if (ime != "") {
      restoreIme := CustomHotkey.Util.Ime.getStatus()
      CustomHotkey.Util.Ime.setStatus(ime)
    }

    splitedKeys := this._splitKeys(keys)
    if (0 < data.limitLength) {
      splitedKeys := this._truncateKeys(splitedKeys, data.limitLength)
    }

    delay := CustomHotkey.Util.isNonEmpty(data.delay) ? data.delay : A_KeyDelay
    pressDuration := CustomHotkey.Util.isNonEmpty(data.pressDuration) ? data.pressDuration : A_KeyDuration
    sendLevel := data.sendLevel ? data.sendLevel : A_SendLevel
    SendLevel, %sendLevel%
    SendMode, % data.mode
    rawOrText := ""
    blind := ""
    modifiers := ""
    isEscapeKeyinTrigger := new CustomHotkey.Trigger(A_ThisHotkey).includes("Esc")
    for i, key in splitedKeys {
      if (key ~= "^(\^|\+|!|#)$") {
        modifiers .= key
        continue
      }
      if (isEscapeKeyinTrigger) {
        if (!GetKeyState("Esc", "P")) {
          isEscapeKeyinTrigger := !isEscapeKeyinTrigger
        }
      }
      else if (GetKeyState("Esc", "P")) {
        break
      }

      if (rawOrText == "" && key ~= "i)^\{text|raw\}$") {
        rawOrText := key
        continue
      }
      else if (blind == "" && CustomHotkey.Util.equalsIgnoreCase(key, "{blind}")) {
        blind := key
        continue
      }
      if (-1 < pressDuration && key ~= "\{[^\s}]+\}") {
        Send, % StrReplace(key, "}", " down}")
        Sleep, %pressDuration%
        Send, % StrReplace(key, "}", " up}")
      }
      else {
        Send, %blind%%rawOrText%%modifiers%%key%
      }

      if (-1 < delay) {
        Sleep, %delay%
      }
      modifiers := ""
    }
    SendMode, %sendMode_bk%
    SendLevel, %sendLevel_bk%

    if (restoreDelay_ms && restoreIme != -1) {
      restoreDelay_ms := Abs(restoreDelay_ms)
      callback := ObjBindMethod(CustomHotkey.Util.Ime, "setStatus", restoreIme)
      SetTimer, %callback%, -%restoreDelay_ms%, 2147483647
    }
  }
  /**
   * @private
   * @param {string} keys
   * @return {string[]}
   */
  _splitKeys(keys) {
    splitedKeys := CustomHotkey.Util.regexSplit(keys, "\{.+?\}|.", "")

    normalized := []
    for i, key in splitedKeys {
      match := CustomHotkey.Util.regexMatch(key, "\{(?<key>[^\s]+)\s+(?<repeat>\d)\}")
      if (!match) {
        match := CustomHotkey.Util.regexMatch(key, "i)\{(?<key>Click\s+\d+\s+\d+)\s+(?<repeat>\d)\}")
      }
      if (match && !(match.key ~= "i)^(asc)$")) {
        Loop % match.repeat
        {
          normalized.push("{" . match.key . "}")
        }
        continue
      }
      normalized.push(key)
    }
    return normalized
  }
  /**
   * Truncate to the number of keys specified.
   * If `{Raw}` or `{Text}` is not present or precedes the string, the length of the portion enclosed in curly brackets is counted as 1.
   *
   * The following keywords are not counted.
   * * `{Raw}`
   * * `{Text}`
   * * `{Blind}`
   * @private
   * @param {string[]} keys
   * @param {number} limit
   * @return {string}
   */
  _truncateKeys(keys, limit) {
    count := 0
    truncated := []
    for i, key in keys {
      if (limit <= count) {
        break
      }
      if (key ~= "i)^\{(raw|text)\}$") {
        restCount := limit - count
        truncated.push(CustomHotkey.Util.subArray(keys, i, restCount)*)
        break
      }
      if (key ~= "^{blind}$") {
        truncated.push(key)
        continue
      }
      truncated.push(key)
      count++
    }
    return truncated
  }
}