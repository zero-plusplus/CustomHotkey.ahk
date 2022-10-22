class Trigger {
  _raw := ""
  ;; @type {string}
  ;; +^!s or a & b
  ;; ↑↑↑↑    ↑↑↑↑↑
  raw {
    get {
      return this._raw
    }
  }
  ;; @type {boolean}
  pressing[] {
    get {
      pressing := CustomHotkey.Util.toBoolean(GetKeyState(this.key, "P"))
      return pressing
    }
  }
  ;; @type {boolean}
  pressingModifiers[] {
    get {
      for i, modifier in this.modifiers {
        if (!GetKeyState(modifier, "P")) {
          return false
        }
      }
      return true
    }
  }
  ;; @type {boolean}
  pressingAll[] {
    get {
      keys := []
      keys.push(this.modifiers*)
      keys.push(this.key)

      for i, key in keys {
        if (!GetKeyState(key, "P")) {
          return false
        }
      }
      return true
    }
  }
  ;; @type {boolean}
  ;; not: +^!s
  ;; yes: a & b
  ;;      ↑↑↑↑↑
  isCombination {
    get {
      return CustomHotkey.Util.toBoolean(InStr(this.raw, "&"))
    }
  }
  ;; @type {boolean}
  ;; not: a
  ;; yes: a up
  ;;        ↑↑
  isReleaseMode {
    get {
      return CustomHotkey.Util.toBoolean(this.raw ~= "i)\sup$")
    }
  }
  ;; yes: a
  ;; not: !a, a & b
  isSingleKey {
    get {
      return this.modifiers.length() == 0
    }
  }
  ;; @type {string}
  ;; +^!s or a & b
  ;; xxx     ↑
  prefixKey {
    get {
      if (this.modifiers.length() == 1) {
        return this.modifiers[1]
      }
    }
  }
  prefixSymbols[index := ""] {
    get {
      flags := []
      for i, char in StrSplit(this.raw) {
        if (char ~= "[*~$]") {
          flags.push(char)
        }
      }

      if (index) {
        return flags[index]
      }
      return flags
    }
  }
  ;; @type {string}
  ;; +^!s or a & b
  ;;    x        ↑
  suffixKey {
    get {
      return this.key
    }
  }
  ;; @type {string}
  ;; +^!s or a & b
  ;;    x        ↑
  secondKey {
    get {
      return this.key
    }
  }
  ;; @type {string}
  ;; +^!s or a & b
  ;; ↑↑↑     ↑
  modifiers[index := ""] {
    get {
      modifiers := []
      if (this.isCombination) {
        rawWithoutFlags := RegExReplace(this.raw, "^([*~$]*)", "")
        RegExMatch(rawWithoutFlags, "O)^(?<prefixKey>[^\s\r\n&]+)", match)
        if (match) {
          modifiers.push(match.prefixKey)
        }
      }
      else {
        modifierSignMap := { "+": "Shift", "<+": "LShift", ">+": "RShift"
                           , "^": "Ctrl", "<^": "LCtrl", ">^": "RCtrl"
                           , "!": "Alt", "<!": "LAlt", ">!": "RAlt"
                           , "#": "Win", "<#": "LWin", ">#": "RWin"
                           , "<^>!": "AltGr" }
        modifier := ""
        for i, char in StrSplit(this.raw) {
          if (!(char ~= "[+^!#<>]")) {
            modifier := ""
            continue
          }

          modifier .= char
          if (ObjHasKey(modifierSignMap, modifier)) {
            modifiers.push(modifierSignMap[modifier])
            modifier := ""
          }
        }
      }

      if (index) {
        return modifiers[index]
      }
      return modifiers
    }
  }
  ;; @type {string}
  ;; +^!s or a & b
  ;;    ↑        ↑
  key {
    get {
      RegExMatch(this.raw ? this.raw : A_ThisHotkey, "iO)(?<key>[^\s~$&+#^!]+)(\s+up)?$", match)
      key := match.key
      return key
    }
  }
  __NEW(rawTrigger) {
    this._raw := CustomHotkey.CustomLabel.replace(rawTrigger)
  }
  /**
   * Determine if they are the same Trigger.
   * @param {string | CustomHotkey.Trigger} trigger
   * @return {boolean}
   */
  equals(trigger) {
    trigger := CustomHotkey.Util.instanceOf(trigger, this)
      ? trigger
      : new CustomHotkey.Trigger(trigger)
    if (!CustomHotkey.Util.deepEqualsIgnoreCase(this.modifiers, trigger.modifiers)) {
      return false
    }
    return CustomHotkey.Util.equalsIgnoreCase(this.key, trigger.key)
  }
  /**
   * Determine if the specified key is included in the Trigger.
   * @param {string} key
   * @return {boolean}
   */
  includes(key) {
    if (CustomHotkey.Util.includesArrayIgnoreCase(this.modifiers, key)) {
      return true
    }
    if (CustomHotkey.Util.equalsIgnoreCase(this.key, key)) {
      return true
    }
    return false
  }
  /**
   * Release a virtual non-modified key.
   * @chainable
   */
  release() {
    key := this.key
    SendInput, {%key% up}
    return this
  }
  /**
   * Release a virtual modified keys.
   * @chainable
   */
  releaseModifiers() {
    for i, modifier in this.modifiers {
      SendInput, {%modifier% up}
    }
    return this
  }
  /**
   * Release all keys specified as Trigger.
   * @chainable
   */
  releaseAll() {
    this.releaseModifiers()
    this.releaseKey()
    return this
  }
  /**
   * Wait until the non-modifier key is released.
   * @chainable
   */
  waitRelease() {
    CustomHotkey.Util.waitReleaseKey(this.key)
  }
  /**
   * Wait until the modifier keys are released.
   * @chainable
   */
  waitReleaseModifiers() {
    CustomHotkey.Util.waitReleaseKey(this.modifiers)
  }
  /**
   * Wait until all keys specified as Trigger is released.
   * @chainable
   */
  waitReleaseAll() {
    keys := []
    keys.push(this.modifiers*)
    keys.push(this.key)
    CustomHotkey.Util.waitReleaseKey(keys)
  }
}