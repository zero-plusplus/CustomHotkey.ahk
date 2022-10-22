class RunAction extends CustomHotkey.ActionBase {
  static defaultOptions := { run: ""
                           , limitArgLength: 1500
                           , args: []
                           , rawArgsMode: false
                           , replace: false
                           , workingDir: ""
                           , wait: false
                           , launchMode: "" } ; "max" | "min" | "hide"
  static prefixRegex := "i)^(?<prefix>{(?<mode>(Run)+)(?:\|(?<options>[^\r\n}]+))?})"
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return data ~= CustomHotkey.RunAction.prefixRegex
    }
    return IsObject(data) && ObjHasKey(data, "run")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.SendAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (!IsObject(data)) {
      prefixRegex := CustomHotkey.RunAction.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (!match) {
        return this.setDefaultOptions({ run: data })
      }

      data := { run: RegExReplace(data, prefixRegex, "") }
      if (match.options) {
        optionDefinitionMap := { "R": { name: "replace", type: "boolean" }
                               , "W": { name: "wait", type: "boolean" }
                               , "M": { name: "launchMode", type: "string" }
                               , "L": { name: "limitArgLength", type: "number" } }
        options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
        data := this.setDefaultOptions(data, options)
      }
    }

    data := this.setDefaultOptions(data)
    if (!IsObject(data.args)) {
      data.args := [ data.args ]
    }
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    run := data.run
    if (CustomHotkey.Util.isCallable(run)) {
      run := CustomHotkey.Util.invoke(run)
    }
    if (data.replace) {
      run := CustomHotkey.Util.templateString(data.run)
    }

    if (data.args.length() == 0) {
      target := run
    }
    else {
      isUrl := run ~= "^http(s)://"
      target := isUrl ? run : """" . run . """"
      for i, arg in data.args {
        if (CustomHotkey.Util.isCallable(arg)) {
          arg := CustomHotkey.Util.invoke(arg)
        }
        if (data.replace) {
          arg := CustomHotkey.Util.templateString(arg)
        }
        if (0 < data.limitArgLength) {
          arg := SubStr(arg, 1, data.limitArgLength)
        }

        if (data.rawArgsMode) {
          target .= isUrl ? arg : " " . arg
          continue
        }

        if (isUrl) {
          isQueryValue := 1 < i && data.args[i - 1] ~= "(^[&?][^=]+=$|/$)"
          target .= isQueryValue ? CustomHotkey.Util.escapeUriComponent(arg) : arg
          continue
        }

        isFlag := CustomHotkey.Util.toBoolean(arg ~= "(^/|^-)")
        target .= isFlag ? " " . arg : " """ . arg . """"
      }
    }

    verb := data.verb ? data.verb . " " : ""
    workingDir := data.workingDir
    if (data.wait) {
      RunWait, %verb%%target%, %workingDir%, % data.launchMode, pid
    }
    else {
      Run, %verb%%target%, %workingDir%, % data.launchMode, pid
    }
    return pid
  }
}