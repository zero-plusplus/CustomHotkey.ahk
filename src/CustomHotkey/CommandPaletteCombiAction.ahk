class CommandPaletteCombiAction extends CustomHotkey.ActionBase {
  static defaultOptions := { tip: { x: 0
                                  , y: 0
                                  , origin: ""
                                  , id: ""
                                  , maxRows: 20
                                  , limitDescriptionLength: 100 }
                           /**
                            * @type {
                            *   | "fuzzy"
                            *   | {
                            *     score: (a: string, b: string, options: { [key: string]: any }) => number;
                            *     parse: (a: string, b: string, options: { [key: string]: any }) => Array<[ string, boolean ]>;
                            *   }
                            * }
                            */
                           , matcher: "fuzzy"
                           ;; @type {{ [key: any]: any }}
                           , matcherOptions: ""
                           /**
                            * @type {
                            *   1 | "serif" | "default"
                            *   2 | "serif-italic"
                            *   3 | "sans-serif"
                            *   4 | "sans-serif-italic"
                            * }
                            */
                           , fontType: 1
                           , caretChar: "|"
                           ;; @type {number}
                           , caretPosition: ""
                           , cursorType: 1
                           , cursorPosition: 1
                           , input: ""
                           , limitInputLength: 100 }
  context := ""
  shouldRestore := true
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (!IsObject(data)) {
      return false
    }

    if (IsObject(data) && ObjHasKey(data, "items")) {
      data := data.items
    }
    if (CustomHotkey.Util.isCallable(data)) {
      data := CustomHotkey.Util.invoke(data)
    }

    if (!CustomHotkey.Util.isArray(data)) {
      return false
    }

    for i, item in data {
      if (ObjHasKey(item, "command") && ObjHasKey(item, "action")) {
        continue
      }
      return false
    }
    return true
  }
  /**
   * @static
   * @param {any} data
   * @return {any}
   */
  normalizeActionData(data) {
    if (CustomHotkey.Util.isArray(data)) {
      data := { items: data }
    }
    data := this.setDefaultOptions(data)

    if (!IsObject(data.matcher)) {
      matcher := CustomHotkey.CommandPaletteCombiAction.Matcher[data.matcher]
      data.matcher := matcher
    }
    if (data.caretPosition == "") {
      data.caretPosition := StrLen(data.input) + 1
    }
    if (!CustomHotkey.Util.isNumber(data.fontType)) {
      fontMap := { "default": 1, "serif": 1
                 , "serif-italic": 2
                 , "sans-serif": 3
                 , "sans-serif-italic": 4 }
      data.fontType := ObjHasKey(fontMap, data.fontType) ? fontMap[data.fontType] : 1
    }
    if (!ObjHasKey(data, alphabetMap)) {
      data.alphabetMap := this._createAlphabetMap(data.fontType)
    }
    if (!ObjHasKey(data, highlightedAlphabetMap)) {
      data.highlightedAlphabetMap := this._createHighlightedAlphabetMap(data.fontType)
    }
    return data
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    if (this.context == "") {
      this.context := { exit: false
                      , shouldWaitKey: ""
                      , input: data.input
                      , caretPosition: data.caretPosition
                      , cursorPosition: data.cursorPosition
                      , maxCaret: StrLen(data.input)
                      , maxItems: 0
                      , first: CustomHotkey.Util.isNonEmptyField(this, "context.first") ? this.context.first : 1
                      , last: CustomHotkey.Util.isNonEmptyField(this, "context.last") ? this.context.last : data.tip.maxRows
                      , tip: new CustomHotkey.Util.ToolTip(data.tip.id)
                      , terminateKeys: {}
                      , hook: InputHook("L0", "{Enter}{Tab}")
                      , hotkeyStateRevertor: CustomHotkey.registeredSingleKeyHotkeys.tempOff() }
      this.context.hook.onChar := ObjBindMethod(this, "onChar")
      this.context.hook.onKeyDown := ObjBindMethod(this, "onKeyDown")
      this.context.hook.onKeyUp := ObjBindMethod(this, "onKeyUp")
      this.context.hook.visibleNonText := false
      this.context.hook.NotifyNonText  := true
      this.context.hook.keyOpt("{Backspace}{Ctrl}{Delete}{Escape}{PgUp}{PgDn}{Home}{End}{Up}{Down}{Left}{Right}{Alt}", "N")
    }
    this.context.hook.start()

    tipPosition := new CustomHotkey.Util.Coordinates(data.tip.x, data.tip.y, data.tip.origin)
    currentInput := this.context.input
    caretPosition := this.context.caretPosition
    cursorPosition := this.context.cursorPosition

    items := CustomHotkey.Util.isCallable(data.items) ? CustomHotkey.Util.invoke(data.items) : data.items
    while (true) {
      Sleep, -1
      if (this.context.forceExit) {
        this.context.hook.stop()
        this.context.tip.close()
        return
      }
      if (this.context.exit) {
        this.context.hook.stop()
        this.context.tip.close()
        this.restoreAction()
        return
      }

      caretChanged := caretPosition != this.context.caretPosition
      this.context.caretPosition := this.context.caretPosition + (StrLen(this.context.input) - StrLen(currentInput))
      inputChanged := CustomHotkey.Util.toString(currentInput) != CustomHotkey.Util.toString(this.context.input) . "" ; For example, "00" is converted to a string so that it is not treated as a `0`
      if (inputChanged || caretChanged) {
        this.context.cursorPosition := 1
      }
      cursorChanged := cursorPosition != this.context.cursorPosition

      currentInput := this.context.input
      this.context.maxCaret := StrLen(currentInput) + 1
      cursorPosition := this.context.cursorPosition
      caretPosition := this.context.caretPosition

      shouldSuggestChanged := !suggests || inputChanged || caretChanged || cursorChanged
      if (shouldSuggestChanged) {
        suggests := this._filter(items, SubStr(currentInput, 1, caretPosition - 1), data)
        this.context.maxItems := suggests.length()

        if (CustomHotkey.Util.isNonEmpty(this.context.first) || CustomHotkey.Util.isNonEmpty(this.context.last)) {
          first := this.context.first
          last := this.context.last
          this.context.first := ""
          this.context.last := ""
        }
        else if (data.tip.maxRows < suggests.length()) {
          if (cursorPosition < first) {
            distance := first - cursorPosition
            first -= distance
            last -= distance
            CustomHotkey.Util.clampNumber(first, 1, this.context.maxItems - data.tip.maxRows)
            CustomHotkey.Util.clampNumber(last, 1, this.context.maxItems)
          }
          else if (last < cursorPosition) {
            distance := cursorPosition - last
            first += distance
            last += distance
            CustomHotkey.Util.clampNumber(first, 1, this.context.maxItems - data.tip.maxRows)
            CustomHotkey.Util.clampNumber(last, 1, this.context.maxItems)
          }
        }
        suggests_viewed := CustomHotkey.Util.subArray(suggests, first, last)

        ;{ Created UI
        suggestsCount_viewed := ObjCount(suggests_viewed)
        barPositionRate := 1 - ((cursorPosition) / suggests.length())
        barPosition := CustomHotkey.Util.clampNumber(suggestsCount_viewed - Floor(barPositionRate * suggestsCount_viewed), 1, suggestsCount_viewed)
        message := this.prevAction ? "[ Esc ] : GO BACK`n`n" : "[ Esc ] : EXIT`n`n"
        message .= Format("{}", CustomHotkey.Util.insertAtString(currentInput, caretPosition, data.caretChar)) . "`n"

        currentInputLength := StrLen(currentInput)
        limitInputLength := Min(20 < currentInputLength ? currentInputLength + 5 : 25, data.limitInputLength)
        message .= CustomHotkey.Util.repeatString("???", limitInputLength) . "`n"
        positionIndicator := Format("???      <{}/{}>", this.context.maxItems == 0 ? 0 : cursorPosition, this.context.maxItems)
        message .= positionIndicator . "`n"
        for i, item in suggests_viewed {
          description := item.desc
          if (item.description) {
            description := item.description
          }
          item.description := description
          description := StrReplace(description, "`r", "``r")
          description := StrReplace(description, "`n", "``n")
          if (description) {
            description := CustomHotkey.Util.truncateString(description, data.tip.limitDescriptionLength)
          }

          segments := ObjBindMethod(data.matcher, "parse", item.command, SubStr(currentInput, 1, caretPosition - 1), this.data.matcherOptions).call()
          command := this._renderCommand(segments)
          icon := item.icon ? item.icon " " : ""
          lineMessage := ""
          if (data.tip.maxRows < suggests.length()) {
            lineMessage .= (A_Index == barPosition) ? " ???" : " ???  "
          }
          else {
            lineMessage .= "??? " ; " ???" " ???  "
          }
          if (CustomHotkey.debugMode) {
            lineMessage .= Format("????{1:03} ", item.score)
          }
          if (cursorPosition == i) {
            lineMessage .= "??? " . icon  . "??? " . command . " ???"
          }
          else {
            lineMessage .= "     " . icon . " [ " . command . " ] "
          }
          if (description && 0 < data.tip.limitDescriptionLength) {
            lineMessage .= " : " . description
          }
          message .= lineMessage . "`n"
        }
        message .= "???"

        ; Fixed an issue where backslash is displayed as a YEN SIGN(??) in Japan
        ; https://ja.wikipedia.org/wiki/%E5%86%86%E8%A8%98%E5%8F%B7#Unicode%E3%81%8C%E6%8C%81%E3%81%A4%E5%95%8F%E9%A1%8C%EF%BC%88%E5%86%86%E8%A8%98%E5%8F%B7%E5%95%8F%E9%A1%8C%EF%BC%89
        if (A_Language == "0411") {
          message := StrReplace(message, "\", "???") ; ?? -> \
        }
        this.context.tip.show(RTrim(message, "`n"), tipPosition)
      }
      ;} Created UI

      if (CustomHotkey.Util.isNonEmpty(this.context.shouldWaitKey) && cursorPosition <= 1 || this.context.maxItems <= cursorPosition) {
        CustomHotkey.Util.waitReleaseKey(this.context.shouldWaitKey)
        this.context.shouldWaitKey := ""
      }

      if (GetKeyState("Alt", "P") && ObjHasKey(suggests_viewed, cursorPosition)) {
        description := suggests_viewed[cursorPosition].description
        this.context.detailTip := new CustomHotkey.Util.ToolTip()
        this.context.detailTip.show(description, tipPosition)
        KeyWait, Alt
        this.context.detailTip.close()
      }

      if (this.context.hook.EndReason == "EndKey") {
        this.context.hook.stop()
        this.context.tip.close()

        selectedItem := suggests[this.context.cursorPosition]
        if (selectedItem && this.context.hook.endKey == "Enter" || this.context.hook.endKey == "Tab") {
          this.context.first := first
          this.context.last := last
          this.executeAction(selectedItem.action)
        }
        return
      }
      if (data.limitInputLength < StrLen(currentInput)) {
        this.context.input := SubStr(currentInput, 1, data.limitInputLength)
      }
      Sleep 16.666
    }
  }
  /**
   * @private
   * @param {Array<{ command: string }>} items
   * @param {any[]} currentInput
   * @param {any[]} data
   * @return {Array<{ command: string; score: number }>}
   */
  _filter(items, currentInput, data) {
    list := []
    for i, item in items {
      score := ObjBindMethod(data.matcher, "score", item.command, currentInput, this.data.matcherOptions).call()
      if (score) {
        item.score := score
        list.push(item)
      }
    }
    if (currentInput != "") {
      list := CustomHotkey.Util.sortArray(list, { key: "score", order: "desc" })
    }
    return list
  }
  /**
   * @private
   * @param {number} fontType
   * @return {CustomHotkey.Util.CaseSensitiveMap | ""}
   */
  _createAlphabetMap(fontType) {
    alphabetsTypes := [ "" ]
    alphabetsTypes.push(new CustomHotkey.Util.CaseSensitiveMap("a", "????", "b", "????", "c", "????", "d", "????", "e", "????", "f", "????", "g", "????", "h", "???", "i", "????", "j", "????", "k", "????", "l", "????", "m", "????", "n", "????", "o", "????", "p", "????", "q", "????", "r", "????", "s", "????", "t", "????", "u", "????", "v", "????", "w", "????", "x", "????", "y", "????", "z", "????", "A", "????", "B", "????", "C", "????", "D", "????", "E", "????", "F", "????", "G", "????", "H", "????", "I", "????", "J", "????", "K", "????", "L", "????", "M", "????", "N", "????", "O", "????", "P", "????", "Q", "????", "R", "????", "S", "????", "T", "????", "U", "????", "V", "????", "W", "????", "X", "????", "Y", "????", "Z", "????"))
    alphabetsTypes.push(new CustomHotkey.Util.CaseSensitiveMap("a", "????", "b", "????", "c", "????", "d", "????", "e", "????", "f", "????", "g", "????", "h", "????", "i", "????", "j", "????", "k", "????", "l", "????", "m", "????", "n", "????", "o", "????", "p", "????", "q", "????", "r", "????", "s", "????", "t", "????", "u", "????", "v", "????", "w", "????", "x", "????", "y", "????", "z", "????", "A", "????", "B", "????", "C", "????", "D", "????", "E", "????", "F", "????", "G", "????", "H", "????", "I", "????", "J", "????", "K", "????", "L", "????", "M", "????", "N", "????", "O", "????", "P", "????", "Q", "????", "R", "????", "S", "????", "T", "????", "U", "????", "V", "????", "W", "????", "X", "????", "Y", "????", "Z", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"))
    alphabetsTypes.push(new CustomHotkey.Util.CaseSensitiveMap("a", "????", "b", "????", "c", "????", "d", "????", "e", "????", "f", "????", "g", "????", "h", "????", "i", "????", "j", "????", "k", "????", "l", "????", "m", "????", "n", "????", "o", "????", "p", "????", "q", "????", "r", "????", "s", "????", "t", "????", "u", "????", "v", "????", "w", "????", "x", "????", "y", "????", "z", "????", "A", "????", "B", "????", "C", "????", "D", "????", "E", "????", "F", "????", "G", "????", "H", "????", "I", "????", "J", "????", "K", "????", "L", "????", "M", "????", "N", "????", "O", "????", "P", "????", "Q", "????", "R", "????", "S", "????", "T", "????", "U", "????", "V", "????", "W", "????", "X", "????", "Y", "????", "Z", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"))
    return alphabetsTypes[fontType]
  }
  /**
   * @private
   * @param {number} fontType
   * @return {CustomHotkey.Util.CaseSensitiveMap}
   */
  _createHighlightedAlphabetMap(fontType) {
    alphabets := [ "a", "b", "c", "d", "e","f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
                 , "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
                 , "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
    highlightedAlphabetsTypes := [ [ "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????","????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????", "????", "????", "????", "????", "????", "????", "????", "????" ]
                                 , [ "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????","????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????", "????", "????", "????", "????", "????", "????", "????", "????" ]
                                 , [ "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????","????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????", "????", "????", "????", "????", "????", "????", "????", "????" ]
                                 , [ "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????","????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????", "????"
                                   , "????", "????", "????", "????", "????", "????", "????", "????", "????", "????" ] ]
    highlightedAlphabets := highlightedAlphabetsTypes[fontType]

    highlightedAlphabetMap := new CustomHotkey.Util.CaseSensitiveMap()
    for i, alphabet in alphabets {
      highlightedAlphabet := highlightedAlphabets[i]
      highlightedAlphabetMap.set(alphabet, highlightedAlphabet)
    }

    highlightedAlphabetMap.set(".", "??")
    highlightedAlphabetMap.set("-", "???")
    highlightedAlphabetMap.set("_", "???")
    highlightedAlphabetMap.set("/", "???")
    highlightedAlphabetMap.set("\", "???")
    return highlightedAlphabetMap
  }
  /**
   * @private
   * @param {Array<[ string, boolean ]>} matchSegments
   * @return {string}
   */
  _renderCommand(matchSegments) {
    alphabetMap := this.data.alphabetMap
    highlightedAlphabetMap := this.data.highlightedAlphabetMap

    command := ""
    for i, segment in matchSegments {
      text := segment[1]
      isMatch := segment[2]
      if (!isMatch) {
        if (alphabetMap) {
          for i, char in StrSplit(text) {
            command .= alphabetMap.has(char) ? alphabetMap.get(char) : char
          }
          continue
        }
        command .= text
        continue
      }

      for i, char in StrSplit(text) {
        command .= highlightedAlphabetMap.has(char) ? highlightedAlphabetMap.get(char) : char
      }
    }
    return command
  }
  /**
   * @event
   */
  onExecuted() {
    CustomHotkey.Util.invoke(this.context.hotkeyStateRevertor)
    this.context.tip.close()
    this.context.detailTip.close()
    this.context.hook.stop()
  }
  /**
   * @event
   * @param {InputHook} hook
   * @param {string} char
   */
  onChar(hook, char) {
    this.context.input := CustomHotkey.Util.insertAtString(this.context.input, this.context.caretPosition, char)
  }
  /**
   * @event
   * @param {InputHook} hook
   * @param {number} vk
   * @param {number} sc
   */
  onKeyDown(hook, vk, sc) {
    if (this.context.shouldWaitKey) {
      return
    }

    pressedCtrl := GetKeyState("Ctrl", "P")
    label := GetKeyName(Format("vk{:x}sc{:x}", VK, SC))
    if (label == "Backspace") {
      if (this.context.input == "") {
        this.context.exit := true
        return
      }

      prevInput := this.context.input
      this.context.input := GetKeyState("Ctrl", "P")
        ? SubStr(this.context.input, this.context.caretPosition)
        : CustomHotkey.Util.removeAtString(this.context.input, this.context.caretPosition - 1, 1)

      if (this.context.shouldWaitKey == "" && StrLen(prevInput) == 1) {
        this.context.shouldWaitKey := "Backspace"
      }
    }
    else if (label == "Delete") {
      this.context.terminateKeys.delete := true
      if (pressedCtrl) {
        newInput := CustomHotkey.Util.removeAtString(this.context.input, this.context.caretPosition, 1)
        this.context.caretPosition += StrLen(this.context.input) - StrLen(newInput)
        this.context.input := newInput
      }
      else {
        this.context.input := CustomHotkey.Util.removeAtString(this.context.input, this.context.caretPosition)
        this.context.caretPosition += 1
      }
    }
    else if (InStr(label, "Alt")) {
      this.context.terminateKeys.alt := true
    }
    else if (InStr(label, "Control")) {
      this.context.terminateKeys.ctrl := true
    }
    else if (label == "Escape") {
      if (pressedCtrl) {
        this.context.forceExit := true
        return
      }
      if (this.context.input == "") {
        this.context.exit := true
        return
      }
      KeyWait, Escape
      this.context.input := ""
    }
    else if (label == "Up") {
      this.context.cursorPosition := pressedCtrl ? 1 : this.context.cursorPosition - 1
      if (this.context.cursorPosition == 1) {
        this.context.shouldWaitKey := "Up"
      }
      else if (this.context.cursorPosition < 1) {
        this.context.cursorPosition := this.context.maxItems
      }
    }
    else if (label == "Down") {
      this.context.cursorPosition := pressedCtrl ? this.context.maxItems : this.context.cursorPosition + 1
      if (this.context.cursorPosition == this.context.maxItems) {
        this.context.shouldWaitKey := "Down"
      }
      else if (this.context.maxItems < this.context.cursorPosition) {
        this.context.cursorPosition := 1
      }
    }
    else if (label == "PgUp") {
      this.context.cursorPosition -= this.data.tip.maxRows
      if (this.context.cursorPosition < 1) {
        this.context.cursorPosition := 1
      }
    }
    else if (label == "PgDn") {
      this.context.cursorPosition += this.data.tip.maxRows
      if (this.context.maxItems < this.context.cursorPosition) {
        this.context.cursorPosition := this.context.maxItems
      }
    }
    else if (label == "Home") {
      this.context.caretPosition := 1
    }
    else if (label == "End") {
      this.context.caretPosition := StrLen(this.context.input) + 1
    }
    else if (label == "Left") {
      this.context.caretPosition := Max(pressedCtrl ? 1 : this.context.caretPosition - 1, 1)
    }
    else if (label == "Right") {
      this.context.caretPosition := Min(pressedCtrl ? this.context.maxCaret : this.context.caretPosition + 1, this.context.maxCaret)
    }

    if (this.context.terminateKeys.ctrl && this.context.terminateKeys.alt && this.context.terminateKeys.delete) {
      this.context.forceExit := true
    }
  }
  /**
   * @event
   * @param {InputHook} hook
   * @param {number} vk
   * @param {number} sc
   */
  onKeyUp(hook, vk, sc) {
    label := GetKeyName(Format("vk{:x}sc{:x}", VK, SC))
    if (InStr(label, "Control")) {
      this.context.terminateKeys.ctrl := false
    }
    else if (InStr(label, "alt")) {
      this.context.terminateKeys.alt := false
    }
    else if (InStr(label, "delete")) {
      this.context.terminateKeys.delete := false
    }
  }
  class Matcher {
    class fuzzy {
      /**
       * @static
       * @param {string[]} chars_a
       * @param {string[]} chars_b
       * @param {{ ignoreCase: boolean }} options
       * @return {{
       *  matchByIndex: { [key: number]: string;
       *  matches: Array<{ index: number, char: string }> }
       * }}
       */
      firstLetterOfWordMatches(chars_a) {
        result := { matchByIndex: {}, matches: [] }
        for i, char_a in chars_a {
          isFirstLetterByWord := i == 1 && char_a ~= "^[^[:punct:]\s]$"
            || (CustomHotkey.Util.isLower(prevChar) && CustomHotkey.Util.isUpper(char_a))
            || (prevChar && (prevChar ~= "^([[:punct:]]|\s)$")) && char_a ~= "^[a-zA-Z]$"
          if (isFirstLetterByWord) {
            result.matchByIndex[i] := char_a
            result.matches.push({ index: i, char: char_a })
          }

          prevChar := char_a
        }
        return result
      }
      /**
       * @static
       * @param {string} char_a
       * @param {string} char_b
       * @param {{
       *  matchByIndex: { [key: number]: string;
       *  matches: Array<{ index: number, char: string }> }
       * }} wordMatchData
       */
      isMatchFirstLetterOfWord(char_a, char_b, index_a, wordMatchData) {
        if (!ObjHasKey(wordMatchData.matchByIndex, index_a)) {
          return false
        }
        if (!CustomHotkey.Util.equals(wordMatchData.matchByIndex[index_a], char_a)) {
          return false
        }
        if (!CustomHotkey.Util.equalsIgnoreCase(char_a, char_b)) {
          return false
        }
        return true
      }
      /**
       * @static
       * @param {string} char_a
       * @param {string} char_b
       * @param {Array<{ index: number; char: string; skippedWord: boolean }>} matches
       * @return {boolean}
       */
      getNextMatchFirstLetterOfWord(char_a, char_b, matches) {
        for i, match in matches {
          if (CustomHotkey.Util.equalsIgnoreCase(match.char, char_b)) {
            match.skippedWord := 1 < i
            return match
          }
        }
      }
      /**
       * @static
       * @param {any} a
       * @param {any} b
       * @param {{ ignoreCase: boolean }} options
       * @return {number}
       */
      score(a, b, options) {
        if (b == "") {
          return 1
        }

        BORNUS := 2
        score := 0
        matchBornus := BORNUS
        exactMatchBornus := BORNUS
        exactAllMatchBornus := BORNUS * 100
        consecutiveBornus := BORNUS
        wordConsecutiveBornus := BORNUS
        startsWithBornus := BORNUS * 2
        firstLetterBornus := BORNUS * 10

        matchResults := this.parseDetail(a, b, options)
        isExactAll := true
        for i, matchResult in matchResults {
          prevMatchResult := matchResults[i - 1]

          if (matchResult.isMatch) {
            score += matchBornus
            score += startsWithBornus
            if (prevMatchResult.isMatch) {
              score += consecutiveBornus
            }
            if (matchResult.containsWordFirstLetter) {
              score += firstLetterBornus
            }
            if (matchResult.substring == matchResult.input) {
              score += matchBornus
            }

            if (prevMatchResult && !prevMatchResult.isMatch && !prevMatchResult.containsWordFirstLetter) {
              prevPrevMatchResult := matchResults[i - 2]
              if (prevPrevMatchResult && (prevPrevMatchResult.isMatch && prevPrevMatchResult.containsWordFirstLetter)) {
                score += wordConsecutiveBornus
              }
            }
            continue
          }
          startsWithBornus := 0
          consecutiveBornus := 0
          isExactAll := false
        }
        if (isExactAll) {
          score += exactAllMatchBornus
        }
        return score
      }
      /**
       * @static
       * @param {any} a
       * @param {any} b
       * @param {{}} options
       * @return {Array<{ substring: string; isMatch: boolean; containsWordFirstLetter: boolean; }>}
       */
      parseDetail(a, b, options) {
        results := []

        chars_a := StrSplit(a)
        chars_b := StrSplit(b)
        length_a := chars_a.length()
        length_b := chars_b.length()
        ignoreCase := true

        wordMatchData := this.firstLetterOfWordMatches(chars_a)
        wordMatches := wordMatchData.matches
        index_a := 1
        index_b := 1
        prevMatchedIndex_a := 0
        allowMatchFirstLetterOfWord := true
        while (index_a <= chars_a.length()) {
          prevResult := results[results.length()]

          char_a := chars_a[index_a]
          if (length_b < index_b) {
            substring := SubStr(a, index_a)
            results.push({ substring: substring
                         , input: ""
                         , start: index_a
                         , end: index_a + StrLen(substrin)
                         , isMatch: false
                         , containsWordFirstLetter: false })
            break
          }
          char_b := chars_b[index_b]

          if (allowMatchFirstLetterOfWord && this.isMatchFirstLetterOfWord(char_a, char_b, index_a, wordMatchData)) {
            results.push({ substring: char_a
                         , input: char_b
                         , start: index_a
                         , end: index_a + StrLen(char_a)
                         , isMatch: true
                         , containsWordFirstLetter: true  })
            prevMatchedIndex_a := index_a
            index_a++
            index_b++

            wordMatches.removeAt(1)
            nextWordMatchIndex := CustomHotkey.Util.findIndexArray(wordMatches, nextWordMatch)
            if (0 < nextWordMatchIndex) {
              wordMatches := CustomHotkey.Util.sliceArray(wordMatches, nextWordMatchIndex)
            }
            continue
          }

          nextWordMatch := this.getNextMatchFirstLetterOfWord(char_a, char_b, wordMatches)
          if (nextWordMatch) {
            forceWordMatch := CustomHotkey.Util.isUpper(char_b)
            allowNextWordMatch := forceWordMatch
              || (!CustomHotkey.Util.startsWithIgnoreCase(char_a, char_b))
            if (allowNextWordMatch) {
              substring := CustomHotkey.Util.sliceString(a, index_a, nextWordMatch.index)
              results.push({ substring: substring
                           , input: ""
                           , start: index_a
                           , end: index_a + StrLen(substring)
                           , isMatch: false
                           , containsWordFirstLetter: nextWordMatch.skippedWord })
              index_a := nextWordMatch.index
              allowMatchFirstLetterOfWord := true
              continue
            }

            allowMatchFirstLetterOfWord := false
          }

          if (CustomHotkey.Util.equalsIgnoreCase(char_a, char_b)) {
            results.push({ substring: char_a
                         , input: char_b
                         , start: index_a
                         , end: index_a + StrLen(char_a)
                         , isMatch: true
                         , containsWordFirstLetter: false })

            prevMatchedIndex_a := index_a
            index_a++
            index_b++
            allowMatchFirstLetterOfWord := true
            continue
          }

          isConsecutiveMatch := false
          results.push({ substring: char_a
                       , input: char_b
                       , start: index_a
                       , end: index_a + StrLen(char_a)
                       , isMatch: false
                       , containsWordFirstLetter: false })
          index_a++
        }
        return results
      }
      /**
       * @static
       * @param {any} a
       * @param {any} b
       * @param {{}} options
       * @return {Array<[ string, boolean ]>}
       */
      parse(a, b, options) {
        if (b == "") {
          return [ [ a, false ] ]
        }

        segments := []
        matchResults := this.parseDetail(a, b, options)
        for i, matchResult in matchResults {
          segments.push([ matchResult.substring, matchResult.isMatch ])
        }
        return segments
      }
    }
  }
}