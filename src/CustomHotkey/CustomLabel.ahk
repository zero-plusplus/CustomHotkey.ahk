class CustomLabel extends CustomHotkey.CustomLabel.Enumerator {
  static defaultJapanesePreset := { Format("{:c}{:c}", 0x5909, 0x63DB): "vk1c" ; 変換
                                  , Format("{:c}{:c}{:c}", 0x7121, 0x5909, 0x63DB): "vk1d" ; 無変換
                                  , Format("{:c}{:c}", 0x534A, 0x89D2): "vkf3" ; 半角
                                  , Format("{:c}{:c}", 0x5168, 0x89D2): "vkf4" ; 全角
                                  , ";": "vkBB"
                                  , ":": "vkBA"
                                  , "_": "vke2" }
  static _items := CustomHotkey.CustomLabel._createDefaultCustomLabels()
  /**
   * Add a specified Custom Label.
   * @static
   * @param {string} aliasLabel
   * @param {string} keyCode
   */
  /**
   * Add all specified Custom Label.
   * @static
   * @param {{ [key: string]: string }} aliasLabels
   * @chainable
   */
  add(params*) {
    customLabels := params[1]
    if (params.length() == 2) {
      customLabels := {}
      customLabels[params[1]] := params[2]
    }

    for label, keyCode in customLabels {
      if (ObjHasKey(this._items, label)) {
        this._items.delete(label)
        this._items[label] := keyCode
        continue
      }

      duplicated := CustomHotkey.Util.findKeyObjectIgnoreCase(this._items, keyCode)
      if (CustomHotkey.Util.isNonEmpty(duplicated)) {
        this._items.delete(duplicated)
      }
      this._items[label] := keyCode
    }
  }
  /**
   * Remove all Custom Labels.
   * @static
   * @param {{ [key: string]: string }} aliasLabels
   * @chainable
   */
  /**
   * Remove a specified Custom Label.
   * @static
   * @param {string} labelOrKeyCode
   * @chainable
   */
  remove(labelOrKeyCode) {
    removeLabels := []
    for label, keyCode in this {
      if (  CustomHotkey.Util.equalsIgnoreCase(labelOrKeyCode, label)
         || CustomHotkey.Util.equalsIgnoreCase(labelOrKeyCode, keyCode)) {
        removeLabels.push(label)
      }
    }

    for i, removeLabel in removeLabels {
      this._items.delete(removeLabel)
    }
    return this
  }
  /**
   * Clear all specified Custom Labels.
   * @static
   * @chainable
   */
  clear() {
    this._items := {}
    return this
  }
  /**
   * @static
   * @return {string}
   */
  replace(trigger) {
    replaced := trigger
    for customLabel, keyCode in CustomHotkey.CustomLabel {
      replaced := RegExReplace(replaced, "i)(?<=^|\s|\b|[+!^#])" customLabel "(?=$|\s|\b)", keyCode)
    }
    return replaced
  }
  /**
   * @static
   * @return {string}
   */
  revert(trigger) {
    replaced := trigger
    for customLabel, keyCode in CustomHotkey.CustomLabel {
      replaced := RegExReplace(replaced, "i)(?<=^|\s|\b|[+!^#])" keyCode "(?=$|\s|\b)", customLabel)
    }
    return replaced
  }
  /**
   * @static
   * @param {string} label
   * @return {string}
   */
  getKeyCode(target) {
    if (ObjHasKey(this._items, target)) {
      return ObjRawGet(this._items, target)
    }
  }
  /**
   * @static
   * @param {string} keyCode
   * @return {string}
   */
  getLabel(target) {
    for label, keyCode in this {
      if (CustomHotkey.Util.equalsIgnoreCase(target, keyCode)) {
        return label
      }
    }
  }
  /**
   * @private
   * @static
   * @return {{ [key: string]: string }}
   */
  _createDefaultCustomLabels() {
    if (A_Language == "0411") { ; jp
      return CustomHotkey.CustomLabel.defaultJapanesePreset
    }
    return {}
  }
  class Enumerator {
    _NewEnum() {
      return this._items._NewEnum()
    }
  }
}