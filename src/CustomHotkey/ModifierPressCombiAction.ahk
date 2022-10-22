class ModifierPressCombiAction extends CustomHotkey.ActionBase  {
  static defaultOptions := { trigger: ""
                           , items: "" }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return false
    }
    if (CustomHotkey.Util.isArray(data)) {
      return false
    }
    if (ObjHasKey(data, "trigger")) {
      return true
    }

    for modifier, item in data {
      if (CustomHotkey.Util.equalsIgnoreCase(modifier, "trigger")) {
        continue
      }

      modifiers := CustomHotkey.Util.isArray(modifier) ? modifier : [ modifier ]
      for i, modifier in modifiers {
        if (!CustomHotkey.Util.includesArrayIgnoreCase(CustomHotkey.Remap.modifiers, modifier)) {
          return false
        }
      }
    }
    return true
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ModifierPressCombiAction.defaultOptions}
   */
  normalizeActionData(data) {
    normalized := this.setDefaultOptions(data)
    normalized.items := this._convertToSortedEntries(data)
    return normalized
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data
    actions := []

    for i, data in data.items {
      modifier := data[1]
      action := data[2]
      if (CustomHotkey.Util.equalsIgnoreCase(modifier, "trigger") || this._checkModifierPress(modifier)) {
        this.executeAction(action)
        return
      }
    }
  }
  /**
   * Convert to an array of modifier key/Action entry.
   * The output is sorted by the number of modifier keys.
   * @private
   * @param {{ [key: string | string[]]: any}}
   * @retun { Array<[ string | string[], any ]>}
   */
  _convertToSortedEntries(data) {
    converted := []

    maxLength := 0
    for modifier in data {
      length := CustomHotkey.Util.isArray(modifier) ? modifier.length() : 1
      if (maxLength < length) {
        maxLength := length
      }
    }

    current := maxLength
    defaultEntry := ""
    while (0 < current) {
      for modifier, action in data {
        if (modifier ~= "i)^default$") {
          defaultEntry := [ modifier, action ]
          continue
        }

        length := CustomHotkey.Util.isArray(modifier) ? modifier.length() : 1
        if (current == length) {
          converted.push([ modifier, action ])
        }
      }
      current--
    }

    if (defaultEntry != "") {
      converted.push(defaultEntry)
    }
    return converted
  }
  /**
   * Determine if the specified modifier key/keys is pressed.
   * @private
   * @param {string | string[]} modifier
   * @return {boolean}
   */
  _checkModifierPress(modifier) {
    modifiers := IsObject(modifier) == true ? modifier: [ modifier ]

    for i, modifier in modifiers {
      if (GetKeyState(modifier, "P") == false) {
        return false
      }
    }
    return true
  }
}