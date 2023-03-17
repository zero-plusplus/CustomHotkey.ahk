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
        message .= CustomHotkey.Util.repeatString("‾", limitInputLength) . "`n"
        positionIndicator := Format("┳      <{}/{}>", this.context.maxItems == 0 ? 0 : cursorPosition, this.context.maxItems)
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
            lineMessage .= (A_Index == barPosition) ? " ▌" : " ╏  "
          }
          else {
            lineMessage .= "┃ " ; " ▌" " ╏  "
          }
          if (CustomHotkey.debugMode) {
            lineMessage .= Format("🏆{1:03} ", item.score)
          }
          if (cursorPosition == i) {
            lineMessage .= "➤ " . icon  . "【 " . command . " 】"
          }
          else {
            lineMessage .= "     " . icon . " [ " . command . " ] "
          }
          if (description && 0 < data.tip.limitDescriptionLength) {
            lineMessage .= " : " . description
          }
          message .= lineMessage . "`n"
        }
        message .= "┻"

        ; Fixed an issue where backslash is displayed as a YEN SIGN(¥) in Japan
        ; https://ja.wikipedia.org/wiki/%E5%86%86%E8%A8%98%E5%8F%B7#Unicode%E3%81%8C%E6%8C%81%E3%81%A4%E5%95%8F%E9%A1%8C%EF%BC%88%E5%86%86%E8%A8%98%E5%8F%B7%E5%95%8F%E9%A1%8C%EF%BC%89
        if (A_Language == "0411") {
          message := StrReplace(message, "\", "⧵") ; ¥ -> \
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
    alphabetsTypes.push(new CustomHotkey.Util.CaseSensitiveMap("a", "𝑎", "b", "𝑏", "c", "𝑐", "d", "𝑑", "e", "𝑒", "f", "𝑓", "g", "𝑔", "h", "ℎ", "i", "𝑖", "j", "𝑗", "k", "𝑘", "l", "𝑙", "m", "𝑚", "n", "𝑛", "o", "𝑜", "p", "𝑝", "q", "𝑞", "r", "𝑟", "s", "𝑠", "t", "𝑡", "u", "𝑢", "v", "𝑣", "w", "𝑤", "x", "𝑥", "y", "𝑦", "z", "𝑧", "A", "𝐴", "B", "𝐵", "C", "𝐶", "D", "𝐷", "E", "𝐸", "F", "𝐹", "G", "𝐺", "H", "𝐻", "I", "𝐼", "J", "𝐽", "K", "𝐾", "L", "𝐿", "M", "𝑀", "N", "𝑁", "O", "𝑂", "P", "𝑃", "Q", "𝑄", "R", "𝑅", "S", "𝑆", "T", "𝑇", "U", "𝑈", "V", "𝑉", "W", "𝑊", "X", "𝑋", "Y", "𝑌", "Z", "𝑍"))
    alphabetsTypes.push(new CustomHotkey.Util.CaseSensitiveMap("a", "𝖺", "b", "𝖻", "c", "𝖼", "d", "𝖽", "e", "𝖾", "f", "𝖿", "g", "𝗀", "h", "𝗁", "i", "𝗂", "j", "𝗃", "k", "𝗄", "l", "𝗅", "m", "𝗆", "n", "𝗇", "o", "𝗈", "p", "𝗉", "q", "𝗊", "r", "𝗋", "s", "𝗌", "t", "𝗍", "u", "𝗎", "v", "𝗏", "w", "𝗐", "x", "𝗑", "y", "𝗒", "z", "𝗓", "A", "𝖠", "B", "𝖡", "C", "𝖢", "D", "𝖣", "E", "𝖤", "F", "𝖥", "G", "𝖦", "H", "𝖧", "I", "𝖨", "J", "𝖩", "K", "𝖪", "L", "𝖫", "M", "𝖬", "N", "𝖭", "O", "𝖮", "P", "𝖯", "Q", "𝖰", "R", "𝖱", "S", "𝖲", "T", "𝖳", "U", "𝖴", "V", "𝖵", "W", "𝖶", "X", "𝖷", "Y", "𝖸", "Z", "𝖹", "𝟢", "𝟣", "𝟤", "𝟥", "𝟦", "𝟧", "𝟨", "𝟩", "𝟪", "𝟫"))
    alphabetsTypes.push(new CustomHotkey.Util.CaseSensitiveMap("a", "𝘢", "b", "𝘣", "c", "𝘤", "d", "𝘥", "e", "𝘦", "f", "𝘧", "g", "𝘨", "h", "𝘩", "i", "𝘪", "j", "𝘫", "k", "𝘬", "l", "𝘭", "m", "𝘮", "n", "𝘯", "o", "𝘰", "p", "𝘱", "q", "𝘲", "r", "𝘳", "s", "𝘴", "t", "𝘵", "u", "𝘶", "v", "𝘷", "w", "𝘸", "x", "𝘹", "y", "𝘺", "z", "𝘻", "A", "𝘈", "B", "𝘉", "C", "𝘊", "D", "𝘋", "E", "𝘌", "F", "𝘍", "G", "𝘎", "H", "𝘏", "I", "𝘐", "J", "𝘑", "K", "𝘒", "L", "𝘓", "M", "𝘔", "N", "𝘕", "O", "𝘖", "P", "𝘗", "Q", "𝘘", "R", "𝘙", "S", "𝘚", "T", "𝘛", "U", "𝘜", "V", "𝘝", "W", "𝘞", "X", "𝘟", "Y", "𝘠", "Z", "𝘡", "𝟢", "𝟣", "𝟤", "𝟥", "𝟦", "𝟧", "𝟨", "𝟩", "𝟪", "𝟫"))
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
    highlightedAlphabetsTypes := [ [ "𝐚", "𝐛", "𝐜", "𝐝", "𝐞", "𝐟", "𝐠", "𝐡", "𝐢", "𝐣", "𝐤", "𝐥", "𝐦", "𝐧", "𝐨", "𝐩", "𝐪", "𝐫", "𝐬", "𝐭", "𝐮", "𝐯", "𝐰", "𝐱", "𝐲", "𝐳"
                                   , "𝐀", "𝐁","𝐂", "𝐃", "𝐄", "𝐅", "𝐆", "𝐇", "𝐈", "𝐉", "𝐊", "𝐋", "𝐌", "𝐍", "𝐎", "𝐏", "𝐐", "𝐑", "𝐒", "𝐓", "𝐔", "𝐕", "𝐖", "𝐗", "𝐘", "𝐙"
                                   , "𝟎", "𝟏", "𝟐", "𝟑", "𝟒", "𝟓", "𝟔", "𝟕", "𝟖", "𝟗" ]
                                 , [ "𝒂", "𝒃", "𝒄", "𝒅", "𝒆", "𝒇", "𝒈", "𝒉", "𝒊", "𝒋", "𝒌", "𝒍", "𝒎", "𝒏", "𝒐", "𝒑", "𝒒", "𝒓", "𝒔", "𝒕", "𝒖", "𝒗", "𝒘", "𝒙", "𝒚", "𝒛"
                                   , "𝑨", "𝑩","𝑪", "𝑫", "𝑬", "𝑭", "𝑮", "𝑯", "𝑰", "𝑱", "𝑲", "𝑳", "𝑴", "𝑵", "𝑶", "𝑷", "𝑸", "𝑹", "𝑺", "𝑻", "𝑼", "𝑽", "𝑾", "𝑿", "𝒀", "𝒁"
                                   , "𝟎", "𝟏", "𝟐", "𝟑", "𝟒", "𝟓", "𝟔", "𝟕", "𝟖", "𝟗" ]
                                 , [ "𝗮", "𝗯", "𝗰", "𝗱", "𝗲", "𝗳", "𝗴", "𝗵", "𝗶", "𝗷", "𝗸", "𝗹", "𝗺", "𝗻", "𝗼", "𝗽", "𝗾", "𝗿", "𝘀", "𝘁", "𝘂", "𝘃", "𝘄", "𝘅", "𝘆", "𝘇"
                                   , "𝗔", "𝗕","𝗖", "𝗗", "𝗘", "𝗙", "𝗚", "𝗛", "𝗜", "𝗝", "𝗞", "𝗟", "𝗠", "𝗡", "𝗢", "𝗣", "𝗤", "𝗥", "𝗦", "𝗧", "𝗨", "𝗩", "𝗪", "𝗫", "𝗬", "𝗭"
                                   , "𝟬", "𝟭", "𝟮", "𝟯", "𝟰", "𝟱", "𝟲", "𝟳", "𝟴", "𝟵" ]
                                 , [ "𝙖", "𝙗", "𝙘", "𝙙", "𝙚", "𝙛", "𝙜", "𝙝", "𝙞", "𝙟", "𝙠", "𝙡", "𝙢", "𝙣", "𝙤", "𝙥", "𝙦", "𝙧", "𝙨", "𝙩", "𝙪", "𝙫", "𝙬", "𝙭", "𝙮", "𝙯"
                                   , "𝘼", "𝘽","𝘾", "𝘿", "𝙀", "𝙁", "𝙂", "𝙃", "𝙄", "𝙅", "𝙆", "𝙇", "𝙈", "𝙉", "𝙊", "𝙋", "𝙌", "𝙍", "𝙎", "𝙏", "𝙐", "𝙑", "𝙒", "𝙓", "𝙔", "𝙕"
                                   , "𝟬", "𝟭", "𝟮", "𝟯", "𝟰", "𝟱", "𝟲", "𝟳", "𝟴", "𝟵" ] ]
    highlightedAlphabets := highlightedAlphabetsTypes[fontType]

    highlightedAlphabetMap := new CustomHotkey.Util.CaseSensitiveMap()
    for i, alphabet in alphabets {
      highlightedAlphabet := highlightedAlphabets[i]
      highlightedAlphabetMap.set(alphabet, highlightedAlphabet)
    }

    highlightedAlphabetMap.set(".", "۔")
    highlightedAlphabetMap.set("-", "⁃")
    highlightedAlphabetMap.set("_", "‗")
    highlightedAlphabetMap.set("/", "⌿")
    highlightedAlphabetMap.set("\", "⍀")
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

              nextWordMatchIndex := CustomHotkey.Util.findIndexArray(wordMatches, nextWordMatch)
              wordMatches := CustomHotkey.Util.sliceArray(wordMatches, nextWordMatchIndex + 1)
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