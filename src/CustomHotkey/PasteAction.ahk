class PasteAction extends CustomHotkey.ActionBase {
  static defaultOptions := { paste: ""
                           , replace: false
                           , restoreClipboard: "150ms" }
  static prefixRegex := "i)^(?<prefix>{(?<mode>Paste)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return data ~= CustomHotkey.PasteAction.prefixRegex
    }
    return IsObject(data) && ObjHasKey(data, "paste")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.PasteAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.PasteAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.setDefaultOptions({ paste: data })
      }

      data := { paste: RegExReplace(data, prefixRegex, "") }
      if (match.options) {
        optionDefinitionMap := { "R": { name: "replace", type: "boolean" }
                               , "C": { name: "restoreClipboard", type: "time" } }
        options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
        data := this.setDefaultOptions(data, options)
      }
    }

    if (data.restoreClipboard == true) {
      data.restoreClipboard := CustomHotkey.PasteAction.defaultOptions.restoreClipboard
    }
    data := this.setDefaultOptions(data)
    data.restoreClipboard := CustomHotkey.Util.timeunit(data.restoreClipboard, "ms")
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    text := data.replace
      ? CustomHotkey.Util.templateString(data.paste)
      : data.paste
    CustomHotkey.Util.pasteClipboard(text, data.restoreClipboard)
  }
}