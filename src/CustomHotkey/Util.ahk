
class Util {
  /**
   * If `expression` is falsy, an exception is raised.
   * @static
   * @param {any} expression
   */
  assert(expression) {
    if (!expression) {
      throw Exception("Failed test.")
    }
  }
  /**
   * @static
   * @param {any} a
   * @param {any} b
   * @param {boolean} [ignoreCase := false]
   * @return {boolean}
   */
  equals(a, b, ignoreCase := false) {
    if (ignoreCase) {
      return CustomHotkey.Util.equalsIgnoreCase(a, b)
    }
    return a == b
  }
  /**
   * @static
   * @param {any} a
   * @param {any} b
   * @return {boolean}
   */
  equalsIgnoreCase(a, b) {
    if (IsObject(a) || IsObject(b)) {
      return a == b
    }
    stringCaseSense_bk := A_StringCaseSense

    StringCaseSense, Off
    result := (a = b)
    StringCaseSense, %stringCaseSense_bk%

    return result
  }
  /**
   * @static
   * @param {any} a
   * @param {any} b
   * @retun {boolean}
   */
  deepEquals(a, b, equiv := "", _stack := "") {
    _stack := _stack ? _stack : []
    equiv := equiv ? equiv : ObjBindMethod(CustomHotkey.Util, "equals")
    if (equiv == true) {
      equiv := ObjBindMethod(CustomHotkey.Util, "equalsIgnoreCase")
    }

    simpleEqualsResult := CustomHotkey.Util.invoke(equiv, a, b)
    if (!(IsObject(a) && IsObject(b))) {
      return simpleEqualsResult
    }

    if (simpleEqualsResult) {
      return true
    }

    isCircular := CustomHotkey.Util.includesArrayIgnoreCase(_stack, a)
    if (isCircular) {
      return false
    }
    _stack.push(a)

    keys_a := CustomHotkey.Util.getOwnKeysObject(a)
    keys_b := CustomHotkey.Util.getOwnKeysObject(b)

    if (keys_a.length() != keys_b.length()) {
      return false
    }

    Loop % keys_a.length()
    {
      result := CustomHotkey.Util.invoke(equiv, keys_a[A_Index], keys_b[A_Index])
      if (!result) {
        return false
      }
    }

    for i, key in keys_a {
      value_a := a[key]
      value_b := b[key]

      if (!CustomHotkey.Util.deepEquals(value_a, value_b, equiv, _stack)) {
        return false
      }
    }
    return true
  }
  /**
   * @static
   * @param {any} a
   * @param {any} b
   * @retun {boolean}
   */
  deepEqualsIgnoreCase(a, b) {
    return CustomHotkey.Util.deepEquals(a, b)
  }
  /**
   * @static
   * @param {object} obj
   * @return {any}
   */
  findObject(obj, searchValue, ignoreCase := false) {
    return CustomHotkey.Util.findArray(obj, searchValue, ignoreCase)
  }
  /**
   * @static
   * @param {object} obj
   * @return {any}
   */
  findKeyObject(obj, searchValue, ignoreCase := false) {
    return CustomHotkey.Util.findIndexArray(obj, searchValue, ignoreCase)
  }
  /**
   * @static
   * @param {object} obj
   * @return {any}
   */
  findKeyObjectIgnoreCase(obj, searchValue) {
    return CustomHotkey.Util.findIndexArray(obj, searchValue, true)
  }
  /**
   * @static
   * @param {object} obj
   */
  clearObject(obj) {
    keys := []
    for key in obj {
      keys.push(key)
    }
    for i, key in keys {
      obj.delete(key)
    }
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  toBoolean(value) {
    return !!value
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  toString(value) {
    return value . ""
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  toNumber(value) {
    return value + 0
  }
  /**
   * @static
   * @param {number} num
   * @return {string}
   */
  toBinary(num) {
    num := Format("{:d}", num) + 0
    if (num == "") {
      return
    }
    if (num == 0) {
      return 0
    }

    binaries := []
    while (0 < num) {
      binaries.push(Mod(num, 2))
      num := Floor(num / 2)
    }
    binary := CustomHotkey.Util.joinArray(CustomHotkey.Util.reverseArray(binaries), "")
    byteCount := StrLen(binary) // 4
    if (byteCount == 4) {
      return binary
    }
    bitCount := (byteCount + 1) * 4
    binary := Format("{:0" bitCount "}", binary)
    return binary
  }
  /**
   * @static
   * @param {number} binary
   * @return {number}
   */
  binaryToDecimal(binary) {
    binaries := CustomHotkey.Util.reverseArray(StrSplit(binary))
    decimal := 0
    Loop % binaries.length()
    {
      decimal += (2 ** (A_Index - 1)) * binaries[A_Index]
    }
    return decimal
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toUpperCase(str) {
    return Format("{:U}", str)
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toLowerCase(str) {
    return Format("{:L}", str)
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toTitleCase(str) {
    return Format("{:T}", str)
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toCamelCase(str) {
    words := CustomHotkey.Util.words(str)

    cameled := ""
    for i, word in words {
      cameled .= CustomHotkey.Util.toTitleCase(word)
    }
    return cameled
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toSpaceCase(str) {
    words := CustomHotkey.Util.words(str)
    converted := CustomHotkey.Util.joinArray(words, " ")
    return converted
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toCapitalizeWord(str) {
    words := CustomHotkey.Util.words(str)

    convertedWords := []
    for i, word in words {
      convertedWords.push(Format("{:T}", word))
    }
    converted := CustomHotkey.Util.joinArray(convertedWords, " ")
    return converted
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toSentenceCase(str) {
    words := CustomHotkey.Util.words(str)

    convertedWords := [ Format("{:T}", words.removeAt(1)) ]
    for i, word in words {
      convertedWords.push(Format("{:L}", word))
    }
    converted := CustomHotkey.Util.joinArray(convertedWords, " ")
    return converted
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toSnakeCase(str) {
    words := CustomHotkey.Util.words(str)
    converted := CustomHotkey.Util.joinArray(words, "_")
    return converted
  }
  /**
   * @static
   * @param {string} str
   * @return {string}
   */
  toKebabCase(str) {
    words := CustomHotkey.Util.words(str)
    converted := CustomHotkey.Util.joinArray(words, "-")
    return converted
  }
  /**
   * @static
   * @param {string} str
   * @return {string[]}
   */
  words(str) {
    words := []

    matches := CustomHotkey.Util.regexMatchAll(str, "([a-z]+|[A-Z][a-z]+|[a-z]+(?=[A-Z]|_|-|\s|$)|[A-Z]+(?=|_|-|\s|$))")
    for i, match in matches {
      words.push(match[1])
    }
    return words
  }
  /**
   * @static
   * @param {string} str
   * @retrun {string[]}
   */
  lines(str) {
    lines := []

    text := str
    while (true) {
      linebreakPosision := InStr(text, "`r`n")
      if (!linebreakPosision) {
        linebreakPosision := InStr(text, "`n")
      }
      if (!linebreakPosision) {
        lines.push(text)
        break
      }
      lines.push(SubStr(text, 1, linebreakPosision))
      text := SubStr(text, linebreakPosision + 1)
    }
    return lines
  }
  /**
   * @static
   * @param {any} obj
   * @param {any[]} keys
   * @return {boolean}
   */
  hasAllKeys(obj, keys) {
    for i, key in keys {
      if (!ObjHasKey(obj, key)) {
        return false
      }
    }
    return true
  }
  /**
   * @static
   * @param {any} obj
   * @param {any[]} keys
   * @return {boolean}
   */
  hasAnyKeys(obj, keys) {
    for i, key in keys {
      if (ObjHasKey(obj, key)) {
        return true
      }
    }
    return false
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isEmpty(value) {
    if (IsObject(value)) {
      return ObjCount(value) == 0
    }
    return value == ""
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isNonEmpty(value) {
    return !CustomHotkey.Util.isEmpty(value)
  }
  /**
   * @static
   * @param {any} obj
   * @param {any} fieldName
   * @return {boolean}
   */
  isEmptyField(obj, fieldName) {
    if (!IsObject(obj)) {
      return false
    }

    keys := StrSplit(fieldName, ".")
    value := obj[keys*]
    return CustomHotkey.Util.isEmpty(value)
  }
  /**
   * @static
   * @param {any} obj
   * @param {any} fieldName
   * @return {boolean}
   */
  isNonEmptyField(obj, fieldName) {
    return !CustomHotkey.Util.isEmptyField(obj, fieldName)
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isArray(value) {
    result := IsObject(value) ? 0 < value.length() : false
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isEnumerable(value) {
    result := NumGet(&value) == NumGet( &{} )
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isBoundFunc(value) {
    result := NumGet(&value) == NumGet( &(Func("Func").bind()) )
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isGlobalFunc(value) {
    return CustomHotkey.Util.isFunc(value) && !InStr(value.name, ".")
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isCallable(value) {
    result := CustomHotkey.Util.isBoundFunc(value) || CustomHotkey.Util.isFunc(value) || CustomHotkey.Util.isFunctor(value)
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isFunc(value) {
    result := NumGet(&value) == NumGet( &Func("Func") )
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isMethod(value) {
    if (!CustomHotkey.Util.isFunc(value)) {
      return false
    }
    result := CustomHotkey.Util.toBoolean(InStr(value.name, "."))
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isFunctor(value) {
    result := IsObject(value) && CustomHotkey.Util.isCallable(value.call)
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isNumber(value) {
    result := (value + 0) != ""
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isPureNumber(value) {
    result := !IsObject(value) && [ value ].GetCapacity(1) == ""
    return result
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isUpper(value) {
    if value is upper
    {
      return true
    }
    return false
  }
  /**
   * @static
   * @param {any} value
   * @return {boolean}
   */
  isLower(value) {
    if value is lower
    {
      return true
    }
    return false
  }
  /**
   * @static
   * @param {any} value
   * @param {Class} baseClass
   * @return {boolean}
   */
  instanceof(value, baseClass) {
    if (!IsObject(value)) {
      return false
    }

    currentBase := value.base
    while (IsObject(currentBase)) {
      if (currentBase == baseClass) {
        return true
      }
      currentBase := ObjGetBase(currentBase)
    }
    return false
  }
  /**
   * Matche `str` by regular expression.
   * @static
   * @param {string} regex
   * @param {string} str
   * @param {number} [fromIndex := 1]
   * @retrun {RegExMatchInfo}
   */
  regexMatch(str, regex, fromIndex := 1) {
    regex := CustomHotkey.Util.addRegexFlags(regex, "O")
    RegExMatch(str, regex, match, fromIndex)
    return match
  }
  /**
   * @static
   * @param {string} str
   * @param {string} regex
   * @return {RegExMatch}
   */
  regexMatchAll(str, regex, fromIndex := 1, limit := -1) {
    currentPosition := fromIndex

    matches := []
    while (limit == -1 || matches.length() < limit) {
      match := CustomHotkey.Util.regexMatch(str, regex, currentPosition)
      v := match.value
      if (!match) {
        break
      }
      matches.push(match)

      currentPosition := match.pos + match.len
      if (currentPosition == match.pos) {
        break
      }
    }
    return matches
  }
  /**
   * Return an array of string delimited by string that match the regular expression.
   * @param {string} regex
   * @param {string} str
   * @param {string} [omitChars := " `n"]
   * @param {string} [maxParts := -1]
   * @return {string[]}
   */
  regexSplit(str, regex, omitChars := " `t", maxParts := -1) {
    splited := []

    matches := CustomHotkey.Util.regexMatchAll(str, regex)
    current := 1
    target := str
    for i, match in matches {
      pos := match.pos
      len := match.len
      if (-1 < maxParts && maxParts < i) {
        return splited
      }
      sliced := Trim(match.value, omitChars)

      splited.push(sliced)
      current := pos + len
    }

    return splited
  }
  /**
   * @static
   * @param {string} url
   * @param {boolean} escapeBackslash
   * @return {string}
   */
  escapeUriComponent(url, escapeBackslash := false) {
    static escapeMap := { "!": "%21", "$": "%24", "&": "%26", "'": "%27", "(": "%28", ")": "%29"
                        , "*": "%2A", "+": "%2B", ",": "%2C", "-": "%2D", ".": "%2E", "/": "%2F"
                        , ":": "%3A", "=": "%3D", "?": "%3F", "@": "%40", "_": "%5F", "~": "%7E"
                        , "^": "%5E", "``": "%60", "{": "%7B", "}": "%7D" , "|": "%7C", "[": "%5B"
                        , "]": "%5D", """": "%22", "<": "%3C", ">": "%3E", "\": "%5C", "#": "%23"
                        , " ": "%20", "`r": "%0D", "`n": "%0A", "%": "%25" }

    static bitPatterns := { "0x0000-0x007F": "0{}{}{}{}{}{}{}"
                          , "0x0080-0x07FF": "110{}{}{}{}{}10{}{}{}{}{}{}"
                          , "0x0080-0xFFFF": "1110{}{}{}{}10{}{}{}{}{}{}10{}{}{}{}{}{}"
                          , "0x10000-0x10FFFF": "11110{}{}{}10{}{}{}{}{}{}10{}{}{}{}{}{}10{}{}{}{}{}{}" }
    escapedComponent := ""
    for i, char in StrSplit(url) {
      isAscii := CustomHotkey.Util.toBoolean(char ~= "[\x00-\x7F]")
      if (isAscii) {
        escapedComponent .= ObjHasKey(escapeMap, char) ? escapeMap[char] : char
        continue
      }


      char_decimal := Asc(char)
      char_binary := CustomHotkey.Util.toBinary(char_decimal)
      for range_str, bitpattern in bitPatterns {
        range := StrSplit(range_str, "-")
        first := Format("{:d}", range[1])
        last := Format("{:d}", range[2])
        if (first <= char_decimal && char_decimal <= last) {
          unicode_binary := Format(bitpattern, StrSplit(char_binary)*)
          unicode_decimal := CustomHotkey.Util.binaryToDecimal(unicode_binary)
          unicode_hex := Format("{:x}", unicode_decimal)
          Loop % StrLen(unicode_hex) // 2
          {
            escapedComponent .= "%" . SubStr(unicode_hex, (A_Index * 2) - 1, 2)
          }
          break
        }
      }
    }

    if (escapeBackslash) {
      escapedComponent := RegExReplace(escapedComponent, "i)(%2F|%7C)", "%5C$1") ; %2F: "/", %7C: "|"
    }
    return escapedComponent
  }
  /**
   * @static
   * @param {string} regex
   * @return {string}
   */
  escapeRegex(regex) {
    escaped := regex
    for i, char in [ "\", ".", "*", "?", "+", "[", "{", "|", "(", ")", "^", "$" ] {
      escaped := StrReplace(escaped, char, "\" . char)
    }
    return RegExReplace(escaped, "\Q(.+)\E", "\\Q$1\\E")
  }
  /**
   * @static
   * @param {string} regex
   * @param {string} flags
   * @return {string}
   */
  addRegexFlags(regex, flags) {
    added := regex ~= "^(?:(?<flags>[imsxADJUXPOSC`n`r`a]*))(?=\))" ? regex : ")" . regex
    added := CustomHotkey.Util.removeRegexFlags(added, flags)

    added := flags . RegExReplace(added, "^(?:(\w)|[" flags "])*(?=\))", "$1")
    return added
  }
  /**
   * @static
   * @param {string} regex
   * @param {string} flags
   * @return {string}
   */
  removeRegexFlags(regex, flags) {
    flagsRegex := "O)^(?:(?<flags>[imsxADJUXPOSC`n`r`a]*))\)"
    RegExMatch(regex, flagsRegex, match)
    if (!match) {
      return regex
    }

    newFlags := ""
    for i, flag in StrSplit(match.flags) {
      if (InStr(flags, flag)) {
        continue
      }
      newFlags .= flag
    }
    return newFlags ")" RegExReplace(regex, flagsRegex, "")
  }
  /**
   * @static
   * @param {string} str
   * @param {string} prefix
   * @return {boolean}
   */
  startsWith(str, prefix, ignoreCase := false) {
    str_prefix := SubStr(str, 1, StrLen(prefix))
    return ignoreCase ? CustomHotkey.Util.equalsIgnoreCase(str_prefix, prefix) : str_prefix == prefix
  }
  /**
   * @static
   * @param {any} str
   * @param {any} prefix
   * @return {boolean}
   */
  startsWithIgnoreCase(str, prefix) {
    return CustomHotkey.Util.startsWith(str, prefix, true)
  }
  /**
   * @static
   * @param {string} str
   * @param {string} suffix
   * @return {boolean}
   */
  endsWith(str, prefix, ignoreCase := false) {
    str_suffix := SubStr(str, -(StrLen(prefix)) + 1)
    return ignoreCase ? CustomHotkey.Util.equalsIgnoreCase(str_suffix, prefix) : str_suffix == prefix
  }
  /**
   * @static
   * @param {string} str
   * @param {string} substring
   * @return {boolean}
   */
  containsString(str, substring, ignoreCase := false) {
    return InStr(str, substring, !ignoreCase)
  }
  /**
   * @static
   * @param {string} str
   * @param {string} [replaceText := ""]
   * @param {byref<number>} [replacedCount]
   * @param {number} [limit]
   * @param {boolean} [ignoreCase := false]
   * @return {boolean}
   */
  replaceString(str, searchText, replaceText := "", byref replacedCount := "", limit := -1, ignoreCase := false) {
    stringCaseSense_bk := A_StringCaseSense
    StringCaseSense, % ignoreCase ? "Off" : "On"
    StringCaseSense, Off
    result := StrReplace(str, searchText, replaceText, replacedCount, limit)
    StringCaseSense, %stringCaseSense_bk%

    return result
  }
  /**
   * @static
   * @param {string} str
   * @param {string} [replaceText := ""]
   * @param {byref<number>} [replacedCount]
   * @param {number} [limit]
   * @return {boolean}
   */
  replaceIgnoreCaseString(str, searchText, replaceText := "", byref replacedCount := "", limit := -1) {
    return CustomHotkey.Util.replaceString(str, searchText, replaceText, replacedCount, limit, true)
  }
  /**
   * @static
   * @param {string} str
   * @param {number} position
   * @param {string} insertText
   * @return {string}
   */
  insertAtString(str, position, insertText) {
    before := SubStr(str, 1, position - 1)
    after := SubStr(str, position)

    inserted := before . insertText . after
    return inserted
  }
  /**
   * @static
   * @param {string} str
   * @param {number} position
   * @param {string} insertText
   * @return {string}
   */
  spliceString(str, position, deleteCount, insertText) {
    before := SubStr(str, 1, position - 1)
    after := SubStr(str, position + deleteCount)

    spliced := before . insertText . after
    return spliced
  }
  /**
   * @static
   * @param {string} str
   * @param {number} position
   * @return {string}
   */
  removeAtString(str, position, length := 1) {
    before := SubStr(str, 1, position - 1)
    after := SubStr(str, position + length)
    return before . after
  }
  /**
   * @static
   * @param {string} str
   * @param {number} begin
   * @param {number} [end := StrLen(str)]
   */
  sliceString(str, begin, end := "") {
    end := end != "" ? end : StrLen(end)
    return SubStr(str, begin, end - begin)
  }
  /**
   * @static
   * @param {string} str
   * @param {any[]} [variables*]
   * @return {string}
   */
  templateString(str, variables*) {
    templatedText := str
    regex := "Oi)(?<!\\)\{(?<valueOrNameOrIndex>"
      . "'(?:\'|[^\r\n'])*'(?=:|\})" ; 'abc'
      . "|[^:{}\r\n""']*?"           ; abc
      . "|\{[^:\r\n{}""']*}?)"       ; {abc}
      . "(?::(?<flags>[^\r\n}]+))?"  ; :abc
      . "}"

    matches := CustomHotkey.Util.regexMatchAll(templatedText, regex)
    for i, match in matches {
      valueOrNameOrIndex := match["valueOrNameOrIndex"]
      flags := match["flags"]

      extraMatch := CustomHotkey.Util.regexMatch(valueOrNameOrIndex, "^{(?<name>[^\r\n}]+)}$")
      if (extraMatch) {
        extraName := extraMatch.name
        if (CustomHotkey.Util.equalsIgnoreCase(extraName, "SelectedText")) {
          value := CustomHotkey.Util.getSelectedText()
        }
        else if (CustomHotkey.Util.equalsIgnoreCase(extraName, "MonitorCount")) {
          SysGet, value, MonitorCount
        }
        else if (CustomHotkey.Util.equalsIgnoreCase(extraName, "MonitorPrimary")) {
          SysGet, value, MonitorPrimary
        }
        else if (CustomHotkey.Util.isNumber(extraName)) {
          SysGet, value, %extraName%
        }
        else {
          extraMatch := CustomHotkey.Util.regexMatch(extraName, "i)(?<name>^[^\d\r\n]+)(?<number>\d+)?$")
          extraName := extraMatch.name
          number := extraMatch.number
          if (CustomHotkey.Util.equalsIgnoreCase(extraName, "MonitorName")) {
            SysGet, value, MonitorName, %number%
          }
          else if (extraName ~= "i)^(MonitorWorkArea|Monitor)") {
            targetName := RegExReplace(extraName, "i)^(MonitorWorkArea|Monitor)", "")
            targets := targetName == ""
              ? [ "Top", "Left", "Top", "Bottom" ]
              : [ targetName ]

            if (CustomHotkey.Util.equalsIgnoreCase(extraName, "MonitorWorkArea")) {
              SysGet, area, MonitorWorkArea, %number%
            }
            else {
              SysGet, area, Monitor, %number%
            }

            values := []
            for i, target in targets {
              values.push(area%target%)
            }
            value := CustomHotkey.Util.joinArray(values, ",")
          }
        }
      }
      else if (CustomHotkey.Util.startsWith(valueOrNameOrIndex, """") || CustomHotkey.Util.startsWith(valueOrNameOrIndex, "'")) {
        value := SubStr(valueOrNameOrIndex, 2, -1)
      }
      else if (valueOrNameOrIndex == "") {
        index := i
        value := variables[index]
      }
      else if (CustomHotkey.Util.isNumber(valueOrNameOrIndex)) {
        index := valueOrNameOrIndex
        value := variables[index]
      }
      else {
        variableName := valueOrNameOrIndex
        value := ""
        for i, variable in variables {
          if (ObjHasKey(variable, variableName)) {
            value := variable[variableName]
            break
          }
        }
        if (value == "") {
          value := CustomHotkey.Util.getGlobal(variableName)
        }
      }

      if (CustomHotkey.Util.isCallable(value)) {
        value := CustomHotkey.Util.invoke(value)
      }
      if (flags) {
        if (InStr(flags, "W", true)) {
          flags := RegExReplace(flags, "W", "")
          if (InStr(flags, "U", true)) {
            flags := RegExReplace(flags, "U", "")
            value := CustomHotkey.Util.toCapitalizeWord(value)
          }
          if (InStr(flags, "T", true)) {
            flags := RegExReplace(flags, "T", "")
            value := CustomHotkey.Util.toSentenceCase(value)
          }
          else {
            value := CustomHotkey.Util.toSpaceCase(value)
          }
        }
        if (InStr(flags, "S", true)) {
          flags := RegExReplace(flags, "S", "")
          value := CustomHotkey.Util.toSnakeCase(value)
        }
        if (InStr(flags, "K", true)) {
          flags := RegExReplace(flags, "K", "")
          value := CustomHotkey.Util.toKebabCase(value)
        }
        if (InStr(flags, "C", true)) {
          flags := RegExReplace(flags, "C", "")
          value := CustomHotkey.Util.toCamelCase(value)
          if (InStr(flags, "U", true)) {
            flags := RegExReplace(flags, "U", "")
            value := Format("{:U}", SubStr(value, 1, 1)) . SubStr(value, 2)
          }
          if (InStr(flags, "L", true)) {
            flags := RegExReplace(flags, "L", "")
            value := Format("{:L}", SubStr(value, 1, 1)) . SubStr(value, 2)
          }
        }
        if (InStr(flags, "P", true)) {
          flags := RegExReplace(flags, "P", "")
          escapeBackslash := false
          if (InStr(flags, "B", true)) {
            flags := RegExReplace(flags, "B", "")
            escapeBackslash := true
          }
          value := CustomHotkey.Util.escapeUriComponent(value, escapeBackslash)
        }
        if (InStr(flags, "Q")) {
          flags := RegExReplace(flags, "Q", "")
          value := """" . value . """"
        }
        if (InStr(flags, "q")) {
          flags := RegExReplace(flags, "q", "")
          value := "'" . value . "'"
        }
        value := Format("{:" . flags . "}", value)
      }

      templatedText := RegExReplace(templatedText, regex, value, , 1)
    }
    return templatedText
  }
  /**
   * @static
   * @param {string} options
   * @param {{ [key: string]: { name: string; type: "string" | "number" | "boolean" | "time"; default: any }}} defMap
   * @return {{ [key: string]: string }}
   */
  parseOptionsString(options, defMap := "") {
    defMap := defMap ? defMap : {}

    parsed := {}
    for name, def in defMap {
      names := StrSplit(def.name, ".")
      if (ObjHasKey(def, "default")) {
        parsed[names*] := def.default
      }
    }

    for i, option in StrSplit(options, " ") {
      value := ""
      if (option ~= "^[+-]") {
        value := true
        if (option ~= "^[-]") {
          value := false
        }
        option := SubStr(option, 2)
      }

      optionName := SubStr(option, 1, 1)
      def := defMap[optionName]

      name := def.name
      if (CustomHotkey.Util.isEmpty(value)) {
        value := SubStr(option, 2)
      }
      if (def.type ~= "i)^time$") {
        value := CustomHotkey.Util.timeunit(value, "ms")
      }
      else if (def.type ~= "i)^boolean$") {
        if (value == "") {
          value := true
        }
        value := CustomHotkey.Util.toBoolean(value)
      }
      else if (def.type ~= "i)^number$") {
        value := CustomHotkey.Util.toNumber(value)
      }

      if (value == "") {
        value := true
      }

      names := StrSplit(name, ".")
      parsed[names*] := value
    }
    return parsed
  }
  /**
   * @static
   * @param {callable} callable
   * @param {any[]} params*
   * @return {any}
   */
  invoke(callable, params*) {
    if (CustomHotkey.Util.instanceof(callable, CustomHotkey.ActionBase)) {
      return %callable%(params*)
    }
    if (CustomHotkey.Util.isBoundFunc(callable) || CustomHotkey.Util.isGlobalFunc(callable)) {
      return %callable%(params*)
    }
    return %callable%(callable, params*)
  }
  /**
   * @static
   * @param {string} str
   * @param {number} count
   * @return {string}
   */
  repeatString(str, count) {
    repeated := ""
    Loop %count%
    {
      repeated .= str
    }
    return repeated
  }
  /**
   * @static
   * @param {string} str
   * @param {number} limit
   * @return {string}
   */
  truncateString(str, limit) {
    return SubStr(str, 1, limit) . (limit < StrLen(str) ? "..." : "")
  }
  /**
   * @static
   * @param {number} num
   * @param {number} min
   * @param {number} max
   * @return {number}
   */
  clampNumber(num, num_min := "", num_max := "") {
    if (num_min == "") {
      num_min := num
    }
    if (num_max == "") {
      num_max := num
    }
    return Min(Max(num, num_min), num_max)
  }
  /**
   * @static
   * @param {object} obj
   * @param {object} source
   * @return {object}
   */
  defaultsObject(params*) {
    defaulted := {}

    for i, param in params {
      for key, value in param {
        if (!ObjHasKey(defaulted, key)) {
          defaulted[key] := value
        }
      }
    }
    return defaulted
  }
  /**
   * @static
   * @param {object} obj
   * @param {object[]} sources*
   * @return {object}
   */
  class deepDefaultsObject extends CustomHotkey.Util.Functor {
    call(self, params*) {
      defaulted := {}
      stack := CustomHotkey.Util.instanceof(params[params.length()], CustomHotkey.Util.deepDefaultsObject.TraceStack)
        ? params.pop()
        : new CustomHotkey.Util.deepDefaultsObject.TraceStack()
      for i, param in params {
        for key, value in param {
          if (CustomHotkey.Util.isEnumerable(value) || CustomHotkey.Util.isArray(value)) {
            isCircle := CustomHotkey.Util.includesArray(stack, value)
            if (isCircle) {
              continue
            }

            stack.push(value)
            defaulted[key] := CustomHotkey.Util.deepDefaultsObject(defaulted[key], value, stack)
            stack.pop()
            continue
          }
          else if (CustomHotkey.Util.isEmptyField(defaulted, key)) {
            defaulted[key] := value
          }
        }
      }
      return defaulted
    }
    class TraceStack {
    }
  }
  /**
   * @static
   * @param {object} obj
   * @return {object}
   */
  flipObject(obj) {
    flipped := {}
    for key, value in obj {
      flipped[value] := key
    }
    return flipped
  }
  /**
   * @static
   * @param {object} obj
   * @return {any[]}
   */
  getOwnKeysObject(obj) {
    keys := []
    for key in obj {
      keys.push(key)
    }
    return keys
  }
  /**
   * @static
   * @param {any[]} array
   * @param {any[]} prefixArray
   * @return {boolean}
   */
  startsWithArray(array, prefixArray, ignoreCase := false) {
    if (prefixArray.length() == 0) {
      return true
    }

    a := CustomHotkey.Util.sliceArray(array, 1, prefixArray.length())
    b := prefixArray
    return CustomHotkey.Util.deepEquals(a, b, ignoreCase)
  }
  /**
   * @static
   * @param {any[]} array
   * @param {any[]} prefixArray
   * @return {boolean}
   */
  startsWithArrayIgnoreCase(array, prefixArray) {
    return CustomHotkey.Util.startsWithArray(array, prefixArray, true)
  }
  /**
   * @static
   * @param {any[]} array
   * @param {string} searchText
   * @return {boolean}
   */
  includesArray(array, searchText, ignoreCase := false) {
    if (!IsObject(array)) {
      return false
    }

    for i, element in array {
      if (CustomHotkey.Util.equals(element, searchText, ignoreCase)) {
        return true
      }
    }
    return false
  }
  /**
   * @static
   * @param {any[]} array
   * @param {string} searchText
   * @return {boolean}
   */
  includesArrayIgnoreCase(array, searchText) {
    return CustomHotkey.Util.includesArray(array, searchText, true)
  }
  /**
   * @static
   * @param {any[]} arr
   * @param {number} [first := 1]
   * @param {number} [last := arr.length()]
   * @return {array}
   */
  subArray(arr, first := 1, last := "") {
    last := last ? last : arr.length()

    sliced := {}
    for i, value in arr {
      if (i < first) {
        continue
      }
      if (last < i) {
        break
      }
      sliced[i] := value
    }
    return sliced
  }
  /**
   * @static
   * @param {any[]} arr
   * @param {number} [first := 1]
   * @param {number} [last := arr.length()]
   * @return {array}
   */
  sliceArray(arr, first := 1, last := "") {
    last := last ? last : arr.length()

    sliced := []
    count := last - (first - 1)
    Loop %count%
    {
      index := first + (A_Index - 1)
      sliced.push(arr[index])
    }
    return sliced
  }
  /**
   * @static
   * @param {any[]} arr
   * @param {string | { key: any, order: "desc" | "descending" } | (a, b) => number} comparer
   * @return {any[]}
   */
  class sortArray extends CustomHotkey.Util.Functor {
    call(self, arr, comparer := "") {
      comparer := comparer ? comparer : ObjbindMethod(this, "_defaultCompare")
      sorted := this._haifdividing(arr, comparer)
      return sorted
    }
    /**
     * @private
     * @param {any} a
     * @param {any} b
     * @param {"" | "desc" | "descending"} [order := ""]
     */
    _defaultCompare(a, b, order := "") {
      result := a - b
      if (result == "") {
        result := Asc(a) - Asc(b)
      }

      if (result != 0 && order ~= "i)desc|descending") {
        return result * -1
      }
      return result
    }
    /**
     * @private
     * @param {any[]} arr
     * @param {string | { key: any, order: "desc" | "descending" } | (a, b) => number} comparer
     */
    _haifdividing(arr, comparer) {
      dividingPoint := Ceil(arr.length() / 2)
      left := CustomHotkey.Util.sliceArray(arr, 1, dividingPoint)
      right := CustomHotkey.Util.sliceArray(arr, dividingPoint + 1)
      if (1 < dividingPoint) {
        left := this._haifdividing(left, comparer)
        right := this._haifdividing(right, comparer)
      }
      return this._merge(left, right, comparer)
    }
    /**
     * @private
     * @param {any} left
     * @param {any} right
     * @param {string | { key: any, order: "desc" | "descending" } | (a, b) => number} comparer
     */
    _merge(left, right, comparer) {
      merged := []
      while (0 < left.length() || 0 < right.length()) {
        count++
        if (ObjHasKey(left, 1) && !ObjHasKey(right, 1)) {
          merged.push(left.removeAt(1))
          continue
        }
        if (!ObjHasKey(left, 1) && ObjHasKey(right, 1)) {
          merged.push(right.removeAt(1))
          continue
        }
        if (!ObjHasKey(left, 1) && !ObjHasKey(right, 1)) {
          break
        }

        compare := 0
        if (CustomHotkey.Util.isCallable(comparer)) {
          compare := CustomHotkey.Util.invoke(comparer, left[1], right[1])
        }
        else if (IsObject(comparer)) {
          compare := this._defaultCompare(left[1][comparer.key], right[1][comparer.key], comparer.order)
        }
        else {
          compare := this._defaultCompare(left[1][comparer], right[1][comparer])
        }
        switch (CustomHotkey.Util.clampNumber(compare, -1, 1)) {
          case 0: merged.push(left.removeAt(1))
          case 1: merged.push(right.removeAt(1))
          case -1: merged.push(left.removeAt(1))
        }
      }
      return merged
    }
  }
  /**
   * @static
   * @param {any[]} array
   * @param {number} size
   * @return {array}
   */
  chunkArray(arr, size) {
    chunked := []
    for i, value in arr {
      if (chunk.length() < size) {
        chunked.push(chunk)
        chunk := []
      }
      chunk.push(value)
    }
    return chunked
  }
  /**
   * @static
   * @param {any[]} array
   * @param {string} [separator := ""]
   * @return {boolean}
   */
  joinArray(arr, separator := "") {
    joined := ""
    for i, item in arr {
      joined .= item . separator
    }
    return RTrim(joined, separator)
  }
  /**
   * @static
   * @param {arary} arr
   * @param {arary} value
   * @param {arary} [start := 1]
   * @param {arary} [end := arr.length()]
   */
  fillArray(arr, value, start := 1, end := "") {
    end := end ? end : arr.length()

    Loop % end - (start - 1)
    {
      i := start + (A_Index - 1)
      arr[i] := value
    }
    return arr
  }
  /**
   * @static
   * @param {arary} arr
   * @param {arary} searchValue
   * @param {arary} [ignoreCase := false]
   * @return {any}
   */
  findArray(arr, searchValue, ignoreCase := false) {
    for i, value in arr {
      if (CustomHotkey.Util.equals(searchValue, value, ignoreCase)) {
        return value
      }
    }
  }
  /**
   * @static
   * @param {arary} arr
   * @param {arary} searchValue
   * @param {arary} [ignoreCase := false]
   * @return {any}
   */
  findIndexArray(arr, searchValue, ignoreCase := false) {
    for i, value in arr {
      if (CustomHotkey.Util.equals(searchValue, value, ignoreCase)) {
        return i
      }
    }
    return 0
  }
  /**
   * @static
   * @param {arary} arr
   * @return {arary}
   */
  reverseArray(arr) {
    reversed := []

    maxLength := arr.length()
    Loop %maxLength%
    {
      reverseIndex := maxLength - (A_Index - 1)
      reversed.push(arr[reverseIndex])
    }
    return reversed
  }
  /**
   * @static
   * @param {string[]} keys
   * @param {"P" | "T"} mode
   * @return {boolean}
   */
  getKeysState(keys, mode) {
    pressed := false
    for i, key in keys {
      if (GetKeyState(key, mode)) {
        pressed := true
        break
      }
    }
    return pressed
  }
  /**
   * @static
   * @return {string}
   */
  waitInputKey(endKeys) {
    hook := InputHook("L1", endKeys)
    hook.VisibleText := false
    hook.VisibleNonText := false
    hook.start()
    hook.wait()
    if (hook.endKey) {
      customLabel := CustomHotkey.CustomLabel.getLabel(hook.endKey)
      if (customLabel) {
        return customLabel
      }
      return hook.endKey
    }
    return hook.input
  }
  /**
   * @static
   * @param {string | string[]} key
   */
  waitReleaseKey(key) {
    keys := CustomHotkey.Util.isArray(key) ? key : [ key ]

    isCritical_bk := A_IsCritical
    Critical, Off
    while (true) {
      isAllRelease := true
      for i, key in keys {
        ; Ignore these inputs as they are currently not correctly recognized
        if (key ~= "i)^Wheel(Up|Down|Left|Right)$") {
          continue
        }

        if (GetKeyState(key, "P")) {
          isAllRelease := false
        }
      }

      if (isAllRelease) {
        break
      }
      Sleep, 16.666
    }
    Critical, %isCritical_bk%
  }
  /**
   * @static
   * @param {string | string[]} key
   */
  releaseKey(key) {
    keys := CustomHotkey.Util.isArray(key) ? key : [ key ]
    for i, key in keys {
      Send, {%key% up}
    }
  }
  /**
   * @static
   */
  releaseModifiers() {
    CustomHotkey.Util.releaseKey(CustomHotkey.Remap.modifiers)
  }
  /**
   * @static
   * @param {boolean} [state := true]
   */
  class blockUserInput extends CustomHotkey.Util.Functor {
    static hook := ""
    static enabled := false
    static forceTerminated := false
    call(self, state := true) {
      if (this.hook == "") {
        this.hook := InputHook("L0 I101")
        this.hook.visibleText := false
        this.hook.visibleNonText := false
        this.hook.NotifyNonText  := true
        this.hook.OnKeyDown := ObjBindMethod(this, "onKeyDown")
        this.hook.OnKeyUp := ObjBindMethod(this, "onKeyUp")
      }

      if (this.enabled == state) {
        return
      }

      this.forceTerminated := false
      if (state) {
        this.enabled := true
        this.start()
        return
      }

      this.stop()
    }
    /**
     * Determine if it should be forced termination.
     * @private
     */
    shouldTerminate() {
      return this.ctrl && this.alt && this.delete
    }
    /**
     * Start user input block.
     * @private
     */
    start() {
      if (!this.hook.inProgress) {
        this.hook.start()
        this.enabled := true
      }
    }
    /**
     * Stop user input block.
     * @private
     */
    stop() {
      this.enabled := false
      this.hook.stop()
      this.ctrl := false
      this.alt := false
      this.delete := false
      CustomHotkey.Util.blockUserInput.forceTerminated := false
    }
    /**
     * @event
     */
    onKeyDown(hook, vk, sc) {
      label := GetKeyName(Format("vk{:x}sc{:x}", VK, SC))
      if (InStr(label, "control")) {
        this.ctrl := true
      }
      else if (InStr(label, "alt")) {
        this.alt := true
      }
      else if (InStr(label, "delete")) {
        this.delete := true
      }

      if (this.shouldTerminate()) {
        CustomHotkey.Util.blockUserInput.forceTerminated := true
        this.stop()
      }
    }
    /**
     * @event
     */
    onKeyUp(hook, vk, sc) {
      label := GetKeyName(Format("vk{:x}sc{:x}", VK, SC))
      if (InStr(label, "Control")) {
        this.ctrl := false
      }
      else if (InStr(label, "alt")) {
        this.alt := false
      }
      else if (InStr(label, "delete")) {
        this.delete := false
      }
    }
  }
  /**
   * @static
   * @param {string} data
   */
  setClipboard(data) {
    Clipboard := data
  }
  /**
   * @static
   * @return {string}
   */
  getSelectedText() {
    bk := ClipboardAll
    Clipboard := ""

    ; Wait until the clipboard is modified
    SendInput ^{c}
    while (A_Index < 10 && Clipboard == "") {
      Sleep, 10
    }
    selectedText := Clipboard
    Clipboard := bk
    return selectedText
  }
  /**
   * @static
   * @param {string} str
   */
  pasteClipboard(str, restoreTime := "150ms") {
    if (str == "") {
      return
    }

    ;
    bk := ClipboardAll
    if (restoreTime_ms < 0) {
      ; Restore ClipboardAll using SetTimer with garbled Clipboard
      bk := Clipboard
    }

    Clipboard := ""
    Clipboard := str
    ; Wait until the clipboard is modified
    while (A_Index < 10 && Clipboard == "") {
      Sleep, 10
    }
    SendInput, ^{v}

    restoreTime_ms := CustomHotkey.Util.timeunit(restoreTime, "ms")
    if (0 < restoreTime_ms) {
      Sleep, %restoreTime_ms%
      Clipboard := bk
    }
    else if (restoreTime_ms < 0) {
      CustomHotkey.Util.setTimeout(ObjBindMethod(CustomHotkey.Util, "setClipboard", bk), Abs(restoreTime_ms))
    }
  }
  /**
   * @static
   * @param {string} name
   * @return {any}
   */
  getGlobal(_name_, _defaultValue_ := "") {
    global
    local _isValidName_, _isNested_, _value_, _classHierarchies_, _root_, _keys_
    _isValidName_ := CustomHotkey.Util.toBoolean(_name_ ~= "^[a-zA-Z0-9_@#$.]+$")
    if (!_isValidName_) {
      return
    }

    _isNested_ := InStr(_name_, ".") ? true : false
    if (_isNested_ == false) {
      _value_ :=  %_name_%
    }
    else {
      _classHierarchies_ := StrSplit(_name_, ".")
      _root_ := _classHierarchies_.removeAt(1)
      _keys_ := _classHierarchies_

      _value_ := %_root_%
      if (_keys_) {
        _value_ := _value_[_keys_*]
      }
    }
    return _value_ ? _value_ : _defaultValue_
  }
  /**
   * @static
   * @param {string} winTitle
   * @param {string} [winText := ""]
   * @param {string} [excludeTitle := ""]
   * @param {string} [excludeText := ""]
   * @return {number[]}
   */
  collectHwndList(winTitle, winText := "", excludeTitle := "", excludeText := "") {
    list := []

    WinGet hwndList, List, %winTile%, %winText%, %excludeTitle%, %excludeText%
    Loop %hwndList%
    {
      list.push(hwndList%A_Index%)
    }
    return list
  }
  /**
   * @static
   * @param {string} winTitle
   * @param {string} [winText := ""]
   * @param {string} [excludeTitle := ""]
   * @param {string} [excludeText := ""]
   * @return {number[]}
   */
  collectAllHwndList(params*) {
    detectHiddenWindows_bk := A_DetectHiddenWindows
    detectHiddenText_bk := A_DetectHiddenText
    DetectHiddenWindows, On
    DetectHiddenText, On
    hwndList := CustomHotkey.Util.collectHwndList(params*)
    DetectHiddenWindows, %detectHiddenWindows_bk%
    DetectHiddenText, %detectHiddenText_bk%

    return hwndList
  }
  /**
   * @static
   * @param {string} filePath
   * @param {string} [encoding := "UTF-8"]
   */
  readFile(filePath, encoding := "UTF-8") {
    fileEncoding_bk := A_FileEncoding
    FileEncoding, %encoding%
    FileRead, text, %filePath%
    FileEncoding, %fileEncoding_bk%

    return text
  }
  class DebugLogger extends CustomHotkey.Util.Functor {
    enabled := true
    prevEnabled := false
    __NEW(indentSize := 2) {
      this.indentSize := indentSize
      this.currentIndent := 0
    }
    /**
     * @param {string} log
     * @param {{ [key: string]: string }} variables
     * @chainable
     */
    /**
     * @param {string} log
     * @param {string[]} [variables*]
     * @chainable
     */
    log(message, params*) {
      if (this.enabled && CustomHotkey.debugMode) {
        indent := CustomHotkey.Util.repeatString(" ", this.currentIndent)
        log := CustomHotkey.Util.templateString(message, params*)
        OutputDebug, %indent%%log%`n
      }
      return this
    }
    /**
     * @chainable
     */
    indent()  {
      this.currentIndent += this.indentSize
      return this
    }
    /**
     * @chainable
     */
    dedent() {
      this.currentIndent -= this.indentSize
      return this
    }
    /**
     * @param {boolean} enabled
     * @chainable
     */
    setEnabled(enabled) {
      this.prevEnabled := this.enabled
      this.enabled := enabled
      return this
    }
    /**
     * @chainable
     */
    on() {
      return this.setEnabled(true)
    }
    /**
     * @chainable
     */
    off() {
      return this.setEnabled(false)
    }
    /**
     * @return {callable}
     */
    tempSetEnabled(enabled) {
      this.setEnabled(enabled)
      return ObjBindMethod(this, "setEnabled", this.prevEnabled)
    }
  }
  /**
   * @static
   * @param {string | callback} callback
   * @param {number | string} time
   * @return {CustomHotkey.Util.setTimer.Timer}
   */
  class setTimer extends CustomHotkey.Util.Functor {
    call(self, callback, time, priority := 0) {
      time_ms := CustomHotkey.Util.timeunit(time, "ms")
      SetTimer, %callback%, %time_ms%, %priority%
      return new CustomHotkey.Util.setTimer.Timer(callback)
    }
    class Timer {
      __NEW(callback) {
        this.callback := callback
      }
      /**
       * Turn on the timer.
       */
      on() {
        callback := this.callback
        SetTimer, %callback%, On
      }
      /**
       * Turn off the timer.
       */
      off() {
        callback := this.callback
        SetTimer, %callback%, Off
      }
      /**
       * Delete the timer.
       */
      delete() {
        callback := this.callback
        SetTimer, %callback%, Delete
      }
    }
  }
  /**
   * @static
   * @param {string | callback} callback
   * @param {number | string} time
   * @return {CustomHotkey.Util.setTimer.Timer}
   */
  setTimeout(callback, time, priority := 0) {
    time_ms := Abs(CustomHotkey.Util.timeunit(time, "ms"))
    if (time_ms == 0) {
      time_ms := 1
    }
    timer := CustomHotkey.Util.setTimer(callback, -time_ms, priority)
    return timer
  }
  /**
   * @static
   * @param {`${number}ms` | `${number}s` | `${number}m` | `${number}h`} src
   * @param {"ms" | "s"| "m" | "h"} [src := "ms"]
   * @return {number}
   */
  class timeunit extends CustomHotkey.Util.Functor {
    call(self, src, dest := "ms") {
      negative := false
      if (CustomHotkey.Util.startsWith(src, "+")) {
        src := SubStr(src, 2)
      }
      else if (CustomHotkey.Util.startsWith(src, "-")) {
        negative := true
        src := SubStr(src, 2)
      }
      time := CustomHotkey.Util.toNumber(this.convertTimeUnit(src, dest))
      if (negative) {
        return time * -1
      }
      return time
    }
    /**
     * @param {string} src
     * @param {"ms" | "s" | "m" | "h"} dest
     * @return {number}
     */
    convertTimeUnit(src, dest) {
      match := CustomHotkey.Util.regexMatch(src, "^(?<time>[^\r\na-zA-Z]+)(?<unit>ms|s|m|h)?$")
      if (!match) {
        return
      }

      sign := match.sign ? match.sign : "+"
      time := match.time + 0
      unit := match.unit ? match.unit : "ms"
      if (dest ~= "i)^ms$") {
        if (unit ~= "i)^ms$") {
          return time
        }
        else if (unit ~= "i)^s$") {
          return Floor(time * 1000)
        }
        else if (unit ~= "i)^m$") {
          return Floor(time * 1000) * 60
        }
        else if (unit ~= "i)^h$") {
          return Floor(time * 1000) * 60 * 60
        }
      }
      else if (dest ~= "i)^s$") {
        if (unit ~= "i)^ms$") {
          return Floor(time / 1000)
        }
        else if (unit ~= "i)^s$") {
          return time
        }
        else if (unit ~= "i)^m$") {
          return time * 60
        }
        else if (unit ~= "i)^h$") {
          return time * 60 * 60
        }
      }
      else if (dest ~= "i)^m$") {
        if (unit ~= "i)^ms$") {
          return Floor((time / 60) / 1000)
        }
        else if (unit ~= "i)^s$") {
          return time / 60
        }
        else if (unit ~= "i)^m$") {
          return time
        }
        else if (unit ~= "i)^h$") {
          return time * 60
        }
      }
      else if (dest ~= "i)^h$") {
        if (unit ~= "i)^ms$") {
          return Floor((time / 60 / 60) / 1000)
        }
        else if (unit ~= "i)^s$") {
          return time / 60 / 60
        }
        else if (unit ~= "i)^m$") {
          return time / 60
        }
        else if (unit ~= "i)^h$") {
          return time
        }
      }
    }
  }
  /**
   * @static
   * @param {string} imageFile
   * @param { [ CustomHotkey.Util.Coordinates, CustomHotkey.Util.Coordinates ]
   *        | { x: number, y: number, width: number, height: number } } [targetRect := "window"]
   * @param {{ x: number, y: number } | ""}
   */
  /**
   * @static
   * @param {object} image
   * @param {string} image.path
   * @param {number} [image.pathType]
   * @param {number} [image.imageNumber]
   * @param {number} [image.variation := 0]
   * @param {number} [image.transparent]
   * @param {number} [image.resize := true]
   * @param { "screen"
   *        | "window"
   *        | [ CustomHotkey.Util.Coordinates, CustomHotkey.Util.Coordinates ]
   *        | { x: number, y: number, width: number, height: number } } [targetRect := "window"]
   * @param {{ x: number, y: number } | ""}
   */
  searchImage(imageFile, targetRect := "window") {
    targetRect := new CustomHotkey.Util.Rect(targetRect)
    imageData := CustomHotkey.Util.deepDefaultsObject( IsObject(imageFile) ? imageFile : { path: imageFile }
                                                     , { imageNumber: "", variation: 0, pathType: "", transparent: "", resize: true } )

    imageOptions := []
    if (imageData.imageNumber) {
      imageOptions.push("*Icon" imageData.imageNumber)
    }
    if (IsObject(imageData.resize)) {
      imageOptions.push(imageData.width != "" ? " *w" imageData.width : "")
      imageOptions.push(imageData.height != "" ? " *h" imageData.height : "")
    }
    else if (imageData.resize == false) {
      imageOptions.push("*w0 *h0")
    }
    if (imageData.variation) {
      imageOptions.push("*" . imageData.variation)
    }
    if (imageData.transparent) {
      imageOptions.push("*Trans" . imageData.transparent)
    }

    image := ""
    if (imageData.pathType ~= "i)^bitmap$") {
      image .= "HBITMAP: "
    }
    else if (imageData.pathType ~= "i)^icon$") {
      image .= "HICON: "
    }
    image .= 0 < imageOptions.length()
      ? CustomHotkey.Util.joinArray(imageOptions, " ") . " " . imageData.path
      : imageData.path

    try {
      bk := A_CoordModePixel
      CoordMode, Pixel, Screen
      ImageSearch, imageX, imageY, % targetRect.x1, % targetRect.y1, % targetRect.x2, % targetRect.y2, %image%
      CoordMode, Pixel, %bk%

      if (imageX != "" && imageY != "") {
        return { x: imageX, y: imageY }
      }
    }
  }
  /**
   * @typedef {{
   *   | string
   *   | string[]
   *   | {
   *     title: string;
   *     id: string;
   *     class: string;
   *     pid: string;
   *     exe: string;
   *     group: string;
   *     text: string;
   *     excludeTitle
   *     excludeText
   *   }
   * }} FindWindowMatcher
   * @typedef {{
   *    | 1 | "forward"
   *    | 2 | "partial"
   *    | 3 | "exact"
   *    | 4 | "backward"
   *    | 5 | "regex"
   * }} FindWindoMatchMode
   * @typedef {} FindWindowOptions
   *
   * @static
   * @param {
   *   | string
   *   | {
   *     active: FindWindowMatcher
   *     matchMode: FindWindowMatchMode | { title: FindWindowMatchMode, text: "fast" | "slow" }
   *     ignoreCase: boolean
   *     detectHidden: boolean | "window" | "text"
   *   }
   *   | {
   *     exist: FindWindowMatcher
   *     matchMode: FindWindowMatchMode | { title: FindWindowMatchMode, text: "fast" | "slow" }
   *     ignoreCase: boolean
   *     detectHidden: boolean | "window" | "text"
   * }} data
   * @return {number}
   */
  class findWindow extends CustomHotkey.Util.Functor {
    static prefixRegex := "i)^(?<prefix>{(?<mode>Active|Exist)(?:\|(?<options>[^\r\n}]+))?})"
    call(self, data) {
      data := this.normalizeData(data)

      titleMatchMode_bk := A_TitleMatchMode
      titleMatchModeSpeed_bk := A_TitleMatchModeSpeed
      detectHiddenWindows_bk := A_DetectHiddenWindows
      detectHiddenText_bk := A_DetectHiddenText

      if (CustomHotkey.Util.isNonEmptyField(data, "matchMode.title")) {
        if (data.matchMode.title == 4) {
          SetTitleMatchMode, regex
        }
        else {
          SetTitleMatchMode, % data.matchMode.title
        }
      }
      if (!CustomHotkey.Util.equalsIgnoreCase(A_TitleMatchMode, "regex") && data.ignoreCase) {
        SetTitleMatchMode, regex
      }
      if (CustomHotkey.Util.isNonEmptyField(data, "matchMode.text")) {
        SetTitleMatchMode, % data.matchMode.text
      }

      if (data.detectHidden == true) {
        DetectHiddenWindows, On
        DetectHiddenText, On
      }
      else if (data.detectHidden ~= "i)^window$") {
        DetectHiddenWindows, On
      }
      else if (data.detectHidden ~= "i)^text$") {
        DetectHiddenText, On
      }

      winParams := this._toWinParams(data)
      result := ObjHasKey(data, "exist") || data.detectHidden
        ? WinExist(winParams*)
        : WinActive(winParams*)

      SetTitleMatchMode, %titleMatchMode_bk%
      SetTitleMatchMode, %titleMatchModeSpeed_bk%
      DetectHiddenWindows, %detectHiddenWindows_bk%
      DetectHiddenText, %detectHiddenText_bk%

      return result
    }
    /**
     * @static
     * @param {any} data
     * @return {{ active: any } | { exist: any }}
     */
    normalizeData(data) {
      prefixRegex := CustomHotkey.Util.findWindow.prefixRegex
      match := CustomHotkey.Util.regexMatch(data, prefixRegex)
      if (match) {
        data := CustomHotkey.Util.equalsIgnoreCase(match.mode, "active")
          ? { active: RegExReplace(data, prefixRegex, "") }
          : { exist: RegExReplace(data, prefixRegex, "") }
        if (match.options != "") {
          optionDefinitionMap := { "I": { name: "ignoreCase", type: "boolean", default: false }
                                 , "M": { name: "matchMode", type: "string", default: "" }
                                 , "D": { name: "detectHidden", type: "string", default: false } }
          options := CustomHotkey.Util.parseOptionsString(match.options, optionDefinitionMap)
          data := CustomHotkey.Util.deepDefaultsObject(data, options)
        }
      }

      if (!IsObject(data) || CustomHotkey.Util.isArray(data)) {
        data := { active: data }
      }
      else if (CustomHotkey.Util.hasAnyKeys(data, [ "title", "text", "id", "hwnd", "class", "pid", "exe", "group" ])) {
        data := { active: data }
      }

      if (CustomHotkey.Util.isNonEmptyField(data, "matchMode")) {
        matchModeMap := { 1: 1, "forward": 1
                        , 2: 2, "partial": 2
                        , 3: 3, "exact": 3
                        , 4: 4, "backward": 4
                        , 5: "regex", "regex": "regex" }

        if (!IsObject(data.matchMode)) {
          data.matchMode := { title: matchModeMap[data.matchMode] }
        }
        else if (CustomHotkey.Util.isNonEmptyField(data, "title")) {
          data.matchMode.title := matchModeMap[data.matchMode.title]
        }
      }
      data.ignoreCase := CustomHotkey.Util.isNonEmptyField(data, "ignoreCase") ? data.ignoreCase : false
      data.detectHidden := CustomHotkey.Util.isNonEmptyField(data, "detectHidden") ? data.detectHidden : false
      return data
    }
    /**
     * @static
     * @private
     * @param {string} component
     * @param {FindWindowOptions} options
     * @return {string}
     */
    _nomalizeComponent(component, options) {
      if (options.matchMode == 4 || options.matchMode == 5) {
        regex := component
        if (options.ignoreCase) {
          regex := CustomHotkey.Util.addRegexFlags(regex, "i")
        }
        return regex
      }
      else if (options.ignoreCase) {
        return CustomHotkey.Util.escapeRegEx(component)
      }
      return component
    }
    /**
     * @static
     * @private
     * @param {FindWindowMatcher} matcher
     * @return
     */
    _toWinParams(data) {
      matcher := ObjHasKey(data, "exist") ? data.exist : data.active
      if (CustomHotkey.Util.isArray(matcher)) {
        return matcher
      }
      if (!IsObject(matcher)) {
        if (CustomHotkey.Util.isPureNumber(matcher)) {
          return [ "ahk_id " . matcher ]
        }
        return [ matcher ]
      }
      if (CustomHotkey.Util.isArray(matcher)) {
        return matcher
      }

      winTitle := data.ignoreCase ? "i)" : ""
      if (CustomHotkey.Util.isNonEmptyField(matcher, "title")) {
        if (data.matchMode.title == 1 || data.matchMode.title == 3) {
          winTitle .= "^"
        }
        winTitle .= this._nomalizeComponent(matcher.title, data)
        if (data.matchMode.title == 3 || data.matchMode.title == 4) {
          winTitle .= "$"
        }
      }

      if (CustomHotkey.Util.isNonEmptyField(matcher, "id") || CustomHotkey.Util.isNonEmptyField(matcher, "hwnd")) {
        hwnd := matcher.hwnd ? matcher.hwnd : matcher.id
        winTitle .= " ahk_id " . this._nomalizeComponent(hwnd, data)
      }
      if (CustomHotkey.Util.isNonEmptyField(matcher, "class")) {
        winTitle .= " ahk_class " . this._nomalizeComponent(matcher.class, data)
      }
      if (CustomHotkey.Util.isNonEmptyField(matcher, "pid")) {
        winTitle .= " ahk_pid " . this._nomalizeComponent(matcher.pid, data)
      }
      if (CustomHotkey.Util.isNonEmptyField(matcher, "exe")) {
        winTitle .= " ahk_exe " . this._nomalizeComponent(matcher.exe, data)
      }
      if (CustomHotkey.Util.isNonEmptyField(matcher, "group")) {
        winTitle .= " ahk_group " . this._nomalizeComponent(matcher.group, data)
      }

      return [ winTitle, matcher.text, matcher.excludeTitle, matcher.excludeText ]
    }
  }
  class ToolTip {
    static usageList := [ false, false, false, false, false
                        , false, false, false, false, false
                        , false, false, false, false, false
                        , false, false, false, false, false ]
    autoId[] {
      get {
        for i, usage in CustomHotkey.Util.ToolTip.usageList {
          if (!usage) {
            CustomHotkey.Util.ToolTip.usageList[i] := true
            return i
          }
        }
        CustomHotkey.Util.ToolTip.usageList[1] := true
        return 1
      }
    }
    __NEW(id := "") {
      if (id) {
        CustomHotkey.Util.ToolTip.usageList[id] := true
        this.id := id
      }
      else {
        this.id := this.autoId
      }
    }
    __Delete() {
      CustomHotkey.Util.ToolTip.usageList[this.id] := false
    }
    /**
     * @param {string} message
     * @param {object} config
     * @param {number} [config.x := 0]
     * @param {number} [config.y := 0]
     * @param {string} [config.origin := ""]
     * @param {string} [config.displayTime]
     */
    show(message, config := "") {
      config := CustomHotkey.Util.defaultsObject(config ? config : {}, { x: 0, y: 0, origin: "", displayTime_ms: 0 })
      position := new CustomHotkey.Util.Coordinates(config.x, config.y, config.origin)

      bk := A_CoordModeToolTip
      CoordMode, ToolTip, Screen
      ToolTip, %message%, % position.x, % position.y, % this.id
      CoordMode, ToolTip, %bk%

      displayTime_ms := CustomHotkey.Util.timeunit(config.displayTime, "ms")
      if (0 < displayTime_ms) {
        Sleep, %displayTime_ms%
        this.close()
      }
      else if (displayTime_ms && displayTime_ms < 0) {
        displayTime_ms := Abs(displayTime_ms)
        callback := ObjBindMethod(this, "close")
        SetTimer, %callback%, -%displayTime_ms%, 2147483647
      }
  }
    close() {
      ToolTip, , , , % this.id
    }
  }
  class MonitorInfo {
    _count := 0
    count {
      get {
        return this._count
      }
    }
    __NEW(monitorNumber := "") {
      if (CustomHotkey.Util.isEmpty(monitorNumber)) {
        return this.getActiveMonitor()
      }

      this.number := monitorNumber
      SysGet, monitorInfo, Monitor, %monitorNumber%
      this.rect := new CustomHotkey.Util.Rect([ [ monitorInfoLeft, monitorInfoTop ], [ monitorInfoRight, monitorInfoBottom ] ])
      SysGet, monitorWorkAreaInfo, Monitor, %monitorNumber%
      this.workAreaRect := new CustomHotkey.Util.Rect([ [ monitorWorkAreaInfoLeft, monitorWorkAreaInfoTop ], [ monitorWorkAreaInfoRight, monitorWorkAreaInfoBottom ] ])
    }
    /**
     * @static
     * @return {CustomHotkey.Util.MonitorInfo | ""}
     */
    getActiveMonitor() {
      mouse := new CustomHotkey.Util.Coordinates(0, 0, "mouse")
      mouseRect := new CustomHotkey.Util.Rect(mouse.x, mouse.y, 0, 0)

      SysGet, monitorCount, MonitorCount
      Loop %monitorCount%
      {
        monitorInfo := new CustomHotkey.Util.MonitorInfo(A_Index)
        if (monitorInfo.rect.contains(mouseRect)) {
          return monitorInfo
        }
      }
    }
  }
  /**
   * Calculate the coordinates with the origin at a certain point.
   * @example
   *  coord := new CustomHotkey.Util.Coordinates(0, 0, "caret-bottom-right")
   *  ToolTip, Display ToolTip at caret position, % coord.x, % coord.y
   */
  class Coordinates {
    ; There is no way to get the proper mouse size, so each user must adjust it.
    static mouseCursorWidth := 12
    static mouseCursorHeight := 15
    /**
     * @typedef {
     *  | "window" | "window-top-left" | "window-top" | "window-top-center" | "window-top-right" | "window-left" | "window-middle-left" | "window-center" | "window-middle-center" | "window-right" | "window-middle-right" | "window-bottom-left" | "window-bottom" | "window-bottom-center" | "window-bottom-right"
     *  | "screen" | "screen-top-left" | "screen-top" | "screen-top-center" | "screen-top-right" | "screen-left" | "screen-middle-left" | "screen-center" | "screen-middle-center" | "screen-right" | "screen-middle-right" | "screen-bottom-left" | "screen-bottom" | "screen-bottom-center" | "screen-bottom-right"
     *  | "mouse" | "mouse-top-left" | "mouse-top" | "mouse-top-center" | "mouse-top-right" | "mouse-left" | "mouse-left" | "mouse-middle-left" | "mouse-center" | "mouse-middle-center" | "mouse-right" | "mouse-middle-right" | "mouse-bottom-left" | "mouse-bottom" | "mouse-bottom-center" | "mouse-bottom-right"
     *  | "caret" | "caret-top-left" | "caret-top" | "caret-top-center" | "caret-top-right" | "caret-left" | "caret-left" | "caret-middle-left" | "caret-center" | "caret-middle-center" | "caret-right" | "caret-middle-right" | "caret-bottom-left" | "caret-bottom" | "caret-bottom-center" | "caret-bottom-right"
     *  | { x: number, y: number }
     * } CoordinatesOrigin
     */
    ;; @type {CoordinatesOrigin}
    static defaultOrigin := "window"
    /**
     * @param {number} x
     * @param {number} y
     * @param {CoordinatesOrigin} [origin]
     */
    __NEW(params*) {
      x := params[1] != "" ? params[1] : 0
      y := params[2] != "" ? params[2]: 0
      origin := params.length() == 3 ? params[3] : CustomHotkey.Util.Coordinates.defaultOrigin
      if (origin == "") {
        return { x: "", y: "" }
      }

      rect := ""
      if (origin ~= "i)^window") {
        rect := CustomHotkey.Util.Coordinates.getWindowRect()
      }
      else if (origin ~= "i)^(screen|monitor)") {
        rect := CustomHotkey.Util.Coordinates.getScreenRect(origin)
      }
      else if (origin ~= "i)^caret") {
        rect := CustomHotkey.Util.Coordinates.getCaretRect()
      }
      else if (origin ~= "i)^mouse") {
        rect := CustomHotkey.Util.Coordinates.getMouseRect()
      }
      position := !IsObject(origin)
        ? CustomHotkey.Util.Coordinates.getPositionByOrigin(rect, origin)
        : { x: (origin.x ? origin.x : 0), y: (origin.y ? origin.y : 0)  }

      this.x := position.x + x
      this.y := position.y + y
      this.originalOrigin := origin
      this.origin := "screen"
    }
    /**
     * @static
     * @param {CustomHotkey.Util.Rect} rect
     * @param {CoordinatesOrigin} origin
     * @return {{ x: number, y: number}}
     */
    getPositionByOrigin(rect, origin) {
      x := rect.x1
      y := rect.y1
      x2 := rect.x2
      y2 := rect.y2
      width_half := Floor(rect.width / 2)
      height_half := Floor(rect.height / 2)


      if (origin ~= "-top(-center)?$") {
        return { x: x + width_half, y: y }
      }
      else if (origin ~= "-top-left$") {
        return { x: x, y: y }
      }
      else if (origin ~= "-top-right$") {
        return { x: x2, y: y }
      }
      else if (origin ~= "-bottom-left$") {
        return { x: x, y: y2 }
      }
      else if (origin ~= "-bottom-right$") {
        return { x: x2, y: y2 }
      }
      else if (origin ~= "-(middle-)?right$") {
        return { x: x2, y: y + height_half }
      }
      else if (origin ~= "-bottom(-center)?$") {
        return { x: x + width_half, y: y2 }
      }
      else if (origin ~= "-(middle-)?left$") {
        return { x: x, y: y + height_half }
      }
      else if (origin ~= "-(middle-)?center$") {
        return { x: x + width_half, y: y + height_half }
      }
      else if (IsObject(origin)) {
        return { x: x + origin.x, y: y + origin.y }
      }
      else {
        return { x: x, y: y }
      }
      return { x: "", y: "" }
    }
    /**
     * @static
     * @param {CoordinatesOrigin} origin
     * @return {{ x: number, y: number }}
     */
    getMouseRect() {
      bk := A_CoordModeMouse
      CoordMode, Mouse, Screen
      MouseGetPos, x, y
      CoordMode, Mouse, %bk%

      width := CustomHotkey.Util.Coordinates.mouseCursorWidth
      height := CustomHotkey.Util.Coordinates.mouseCursorHeight
      rect := new CustomHotkey.Util.Rect(x, y, width, height)
      return rect
    }
    /**
     * @static
     * @return {CustomHotkey.Util.Rect}
     */
    getCaretRect() {
      rect := CustomHotkey.Util.Coordinates.getCaretRectByAcc()
      if (rect) {
        return rect
      }

      bk := A_CoordModeMouse
      CoordMode, Caret, Screen
      rect := new CustomHotkey.Util.Rect(A_CaretX, A_CaretY, 2, 2)
      CoordMode, Caret, %bk%
      return rect
    }
    /**
     * @static
     * @return {CustomHotkey.Util.Rect}
     */
    getCaretRectByAcc() {
      static module, VT_BYREF := 0x4000, VT_I4 := 3, BYREF_INT32 := VT_BYREF + VT_I4, OBJID_CARET := 0xFFFFFFF8

      if (!module) {
        module := DllCall("LoadLibrary", "str", "oleacc", "ptr")
      }

      VarSetCapacity(IID_IAccessible, 16)
      DllCall("ole32\CLSIDFromString", "wstr", "{618736e0-3c3d-11cf-810c-00aa00389b71}", "ptr", &IID_IAccessible) ; https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/nf-combaseapi-clsidfromstring
      DllCall("oleacc\AccessibleObjectFromWindow", "ptr", WinActive("A"), "uint", OBJID_CARET, "ptr", &IID_IAccessible, "ptr*", pacc) ; https://learn.microsoft.com/en-us/windows/win32/api/oleacc/nf-oleacc-accessibleobjectfromwindow
      caret := ComObject(9, pacc, 1)

      _x := ComObject(BYREF_INT32, &_x := 0)
      _y := ComObject(BYREF_INT32, &_y := 0)
      _width := ComObject(BYREF_INT32, &_width := 0)
      _height := ComObject(BYREF_INT32, &_height := 0)
      try {
        caret.accLocation(_x, _y, _width, _height, 0)
      }
      catch {
        return
      }

      x := NumGet(_x, 0, "int")
      y := NumGet(_y, 0, "int")
      width := NumGet(_width, 0, "int")
      height := NumGet(_height, 0, "int")
      if (!(x || y || width || height)) {
        return
      }
      return new CustomHotkey.Util.Rect(x, y, width, height)
    }
    /**
     * @static
     * @param {string} origin
     * @return {CustomHotkey.Util.Rect}
     */
    getScreenRect(origin) {
      match := CustomHotkey.Util.regexMatch(origin, "i)^(screen|monitor)(-(?<target>\d|primary))")
      if (!match || CustomHotkey.Util.equalsIgnoreCase(match.target, "primary")) {
        monitorInfo := new CustomHotkey.Util.MonitorInfo()
        return monitorInfo.rect
      }

      monitorInfo := new CustomHotkey.Util.MonitorInfo(match.target)
      return monitorInfo.rect
    }
    /**
     * @static
     * @return {CustomHotkey.Util.Rect}
     */
    getWindowRect() {
      WinGetPos, x, y, width, height, A
      return new CustomHotkey.Util.Rect(x, y, width, height)
    }
  }
  /**
   * Provide properties to get information about the window.
   */
  class WindowInfo {
    __NEW(hwnd := "A") {
      this.hwnd := CustomHotkey.Util.findWindow(hwnd)
    }
    /**
     * Return a title of the active window.
     * @static
     * @type {string}
     */
    title {
      get {
        WinGetTitle, title, % this.ahk_id
        return title
      }
    }
    /**
     * Return a window class of the active window.
     * @static
     * @type {string}
     */
    class {
      get {
        WinGetClass, winClass, % this.ahk_id
        return winClass
      }
    }
    /**
     * It is the same as the `class` property except that it is prefixed with `"ahk_class "`.
     * @static
     * @type {string}
     */
    ahk_class {
      get {
        return "ahk_class " . this.class
      }
    }
    /**
     * Return a window id (hwnd) of the active window.
     * @static
     * @type {string}
     */
    id {
      get {
        if (this.hwnd) {
          return this.hwnd
        }

        WinGet, id, ID, A
        return id
      }
    }
    /**
     * It is the same as the `id` property except that it is prefixed with `"ahk_id "`.
     * @static
     * @type {string}
     */
    ahk_id {
      get {
        return "ahk_id " . this.id
      }
    }
    /**
     * Return a process id of the active window.
     * @static
     * @type {string}
     */
    pid {
      get {
        WinGet, pid, PID, % this.ahk_id
        return pid
      }
    }
    /**
     * It is a same as the `pid` property except that it is prefixed with `"ahk_pid "`.
     * @static
     * @type {string}
     */
    ahk_pid {
      get {
        return "ahk_pid " . this.pid
      }
    }
    /**
     * Return a process name of the active window.
     * @static
     * @type {string}
     */
    exe {
      get {
        WinGet, exe, ProcessName, % this.ahk_id
        return exe
      }
    }
    /**
     * Return a process path of the active window.
     * @static
     * @type {string}
     */
    path {
      get {
        WinGet, path, ProcessPath, % this.ahk_id
        return path
      }
    }
    /**
     * It is the same as the `exe` property except that it is prefixed with `"ahk_exe "`.
     * @static
     * @type {string}
     */
    ahk_exe {
      get {
        return "ahk_exe " . this.exe
      }
    }
    /**
     * Return a window text of the active window.
     * @static
     * @type {string}
     */
    text {
      get {
        WinGetText, text, % this.ahk_id
        return text
      }
    }
  }
  /**
   * This class provides static methods for getting/setting the state of the [Input Method Editor (IME)](https://en.wikipedia.org/wiki/Input_method).
   */
  class Ime {
    /**
     * Get/Set IME status. Enable if `true` IME status, disable if `false`.
     * @static
     * @type {boolean}
     */
    status {
      get {
        return this.getStatus()
      }
      set {
        return this.setStatus(value)
      }
    }
    on() {
      return this.setStatus(true)
    }
    off() {
      return this.setStatus(false)
    }
    /**
     * Get a boolean value representing whether the IME is enabled or disabled.
     * @return {boolean}
     */
    getStatus() {
      static IMC_GETOPENSTATUS := 0x0005

      return !!(this._sendMessage(IMC_GETOPENSTATUS))
    }
    /**
     * Set the IME status.
     * @static
     * @param {boolean} status - Enable if `true`, disable if `false`
     * @throws Error - Throw an exception if the state setting fails
     */
    setStatus(status) {
      static IMC_SETOPENSTATUS := 0x006

      errorCode := this._sendMessage(IMC_SETOPENSTATUS, status)
      if (0 < errorCode) {
        throw Exception("Failed to set status. code: " errorCode)
      }
    }
    /**
     * Common process for sending SendMessage.
     * @private
     * @static
     * @param {number} wParam
     * @param {number} [lParam := 0]
     * @return {any | ""}
     */
    _sendMessage(wParam, lParam := 0) {
      static WM_IME_CONTROL := 0x0283
           , DWORD_SIZE := 4
           , HWND_SIZE := A_PtrSize
           , LONG_SIZE := 4
           , RECT_SIZE := LONG_SIZE * 4
           , TAGGUITHREADINFO_SIZE := (DWORD_SIZE * 2) + (HWND_SIZE * 6) + RECT_SIZE
           , NULL := 0

      try {
        ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-guithreadinfo
        ; typedef struct tagGUITHREADINFO {
        ;   DWORD cbSize;
        ;   DWORD flags;
        ;   HWND  hwndActive;
        ;   HWND  hwndFocus;
        ;   HWND  hwndCapture;
        ;   HWND  hwndMenuOwner;
        ;   HWND  hwndMoveSize;
        ;   HWND  hwndCaret;
        ;   RECT  rcCaret;
        ; } GUITHREADINFO, *PGUITHREADINFO, *LPGUITHREADINFO;
        ;
        ; https://learn.microsoft.com/en-us/windows/win32/api/windef/ns-windef-rect
        ; typedef struct tagRECT {
        ;   LONG left;
        ;   LONG top;
        ;   LONG right;
        ;   LONG bottom;
        ; } RECT, *PRECT, *NPRECT, *LPRECT;

        VarSetCapacity(guiThreadInfo, TAGGUITHREADINFO_SIZE)
        NumPut(TAGGUITHREADINFO_SIZE, guiThreadInfo, 0, "UInt")
        result := DllCall("GetGUIThreadInfo", "Uint", NULL, "Uint", &guiThreadInfo)
        if (result) {
          hwndFocus := NumGet(guiThreadInfo, (DWORD_SIZE * 2) + A_PtrSize, "UInt")
          return DllCall( "SendMessage"
                        , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hwndFocus)
                        , "UInt", msg := WM_IME_CONTROL
                        , "Int", wParam
                        , "Int", lParam )
        }
      }
    }
  }
  /**
   * Provide a way to register or unregister window change event.
   */
  class WindowChangeEvent {
    static _registeredCallbacks := []
    /**
     * `true` if a callback is registered for the window change event, `false` otherwise.
     * @type {boolean}
     */
    isRegistered[] {
      get {
        return 0 < this.id
      }
    }
    /**
     * @param {(windowInfo: WindowChangeEvent.ActiveWindowInfo) => void} callback - Callable object called on window change
     */
    __NEW(callback) {
      this.id := 0

      if (!IsObject(callback)) {
        throw Exception("``callback`` must be a Func, BoundFunc, or user-defined function.")
      }
      CustomHotkey.Util.WindowChangeEvent._registeredCallbacks.push(callback)
      this.callbackNumber := CustomHotkey.Util.WindowChangeEvent._registeredCallbacks.length()
    }
    /**
     * Register a callback to the window change event.
     * @static
     * @param {(windowInfo: WindowChangeEvent.ActiveWindowInfo) => void} callback - Callable object called on window change
     * @return {WindowChangeEvent}
     */
    /**
     * Register a pre-specified callback to the window change event.
     * @chainable
     */
    register(callback := "") {
      ; https://learn.microsoft.com/en-us/windows/win32/winauto/event-constants
      static EVENT_SYSTEM_FOREGROUND := 0x00000003

      ; static method
      if (this == CustomHotkey.Util.WindowChangeEvent) {
        return new CustomHotkey.Util.WindowChangeEvent(callback).register()
      }

      ; instance method
      ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwineventhook
      this.id := DllCall( "SetWinEventHook"
      , "UInt", eventMin := EVENT_SYSTEM_FOREGROUND := 0x00000003
      , "UInt", eventMax := EVENT_SYSTEM_FOREGROUND
      , "UInt", hmodWinEventProc := 0
      , "UInt", pfnWinEventProc := RegisterCallback(Func("CustomHotkey.Util.WindowChangeEvent._callbackWrapper"), "", , this.callbackNumber)
      , "UInt", idProcess := 0
      , "UInt", idThread := 0
      , "UInt", dwFlags := 0 )

      OnExit(ObjBindMethod(this, "unregister"))

      return this
    }
    /**
     * Unregister a registered callback.
     * @chainable
     */
    unregister() {
      if (DllCall("UnhookWinEvent", "UInt", this.id)) {
        this.id := 0
      }
      return this
    }
    /**
     * @private
     * @static
     */
    _callbackWrapper() {
      callback := CustomHotkey.Util.WindowChangeEvent._registeredCallbacks[A_EventInfo]
      %callback%(CustomHotkey.Util.ActiveWindowInfo)
    }
  }
  class RGB {
    static colorMap := CustomHotkey.Util.RGB._createColorMap()
    /**
     * @private
     * @type {string}
     */
    _raw := ""
    /**
     * @type {string}
     */
    raw {
      get {
        return this._raw
      }
    }
    /**
     * @type {string}
     */
    r {
      get {
        red := SubStr(this.raw, 1, 2)
        return red
      }
    }
    /**
     * @type {string}
     */
    g {
      get {
        green := SubStr(this.raw, 3, 2)
        return green
      }
    }
    /**
     * @type {string}
     */
    b {
      get {
        blue := SubStr(this.raw, 5, 2)
        return blue
      }
    }
    /**
     * @type {string}
     */
    hex {
      get {
        hex := "0x" . this.raw
        return hex
      }
    }
    /**
     * @type {string}
     */
    htmlColorCode {
      get {
        htmlColorCode := this.raw ~= "#" ? SubStr(color, 2) : Format("{:x}", color)
        return htmlColorCode
      }
    }
    __NEW(color) {
      this._raw := this._normalizeColor(color)
    }
    /**
     * @return {CustomHotkey.Util.RGB}
     */
    invert() {
      inverted := new CustomHotkey.Util.RGB(Format("{:x}", 255 - this.r . 255 - this.g . 255 - this.b))
      return inverted
    }
    /**
     * @param {string} color
     * @return {string}
     */
    _normalizeColor(color) {
      if (color ~= "^#") {
        colorCode := RegExReplace(color, "^#", "")
        return colorCode
      }
      if (color ~= "^0x") {
        colorCode := RegExReplace(color, "^0x", "")
        return colorCode
      }
      if (CustomHotkey.Util.isPureNumber(color)) {
        colorCode := Format("{:06}", Format("{:x}", color))
        return colorCode
      }
      if (ObjHasKey(CustomHotkey.Util.RGB.colorMap, color)) {
        colorCode := CustomHotkey.Util.RGB.colorMap[color]
        return colorCode
      }
      return color
    }
    /**
     * @private
     * @return {{ [key: string]: string }}
     */
    _createColorMap() {
      ; https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/color_keywords
      ; Dynamically create object to exceed the limit on the maximum number of expression
      colorMap := {}
      colorMap["black"] := "000000"
      colorMap["silver"] := "c0c0c0"
      colorMap["gray"] := "808080"
      colorMap["white"] := "ffffff"
      colorMap["maroon"] := "800000"
      colorMap["red"] := "ff0000"
      colorMap["purple"] := "800080"
      colorMap["fuchsia"] := "ff00ff"
      colorMap["green"] := "008000"
      colorMap["lime"] := "00ff00"
      colorMap["olive"] := "808000"
      colorMap["yellow"] := "ffff00"
      colorMap["navy"] := "000080"
      colorMap["blue"] := "0000ff"
      colorMap["teal"] := "008080"
      colorMap["aqua"] := "00ffff"
      colorMap["antiquewhite"] := "faebd7"
      colorMap["aquamarine"] := "7fffd4"
      colorMap["azure"] := "f0ffff"
      colorMap["beige"] := "f5f5dc"
      colorMap["bisque"] := "ffe4c4"
      colorMap["blanchedalmond"] := "ffebcd"
      colorMap["blueviolet"] := "8a2be2"
      colorMap["brown"] := "a52a2a"
      colorMap["burlywood"] := "deb887"
      colorMap["cadetblue"] := "5f9ea0"
      colorMap["chartreuse"] := "7fff00"
      colorMap["chocolate"] := "d2691e"
      colorMap["coral"] := "ff7f50"
      colorMap["cornflowerblue"] := "6495ed"
      colorMap["cornsilk"] := "fff8dc"
      colorMap["crimson"] := "dc143c"
      colorMap["cyan"] := "00ffff"
      colorMap["darkblue"] := "00008b"
      colorMap["darkcyan"] := "008b8b"
      colorMap["darkgoldenrod"] := "b8860b"
      colorMap["darkgray"] := "a9a9a9"
      colorMap["darkgreen"] := "006400"
      colorMap["darkgrey"] := "a9a9a9"
      colorMap["darkkhaki"] := "bdb76b"
      colorMap["darkmagenta"] := "8b008b"
      colorMap["darkolivegreen"] := "556b2f"
      colorMap["darkorange"] := "ff8c00"
      colorMap["darkorchid"] := "9932cc"
      colorMap["darkred"] := "8b0000"
      colorMap["darksalmon"] := "e9967a"
      colorMap["darkseagreen"] := "8fbc8f"
      colorMap["darkslateblue"] := "483d8b"
      colorMap["darkslategray"] := "2f4f4f"
      colorMap["darkslategrey"] := "2f4f4f"
      colorMap["darkturquoise"] := "00ced1"
      colorMap["darkviolet"] := "9400d3"
      colorMap["deeppink"] := "ff1493"
      colorMap["deepskyblue"] := "00bfff"
      colorMap["dimgray"] := "696969"
      colorMap["dimgrey"] := "696969"
      colorMap["dodgerblue"] := "1e90ff"
      colorMap["firebrick"] := "b22222"
      colorMap["floralwhite"] := "fffaf0"
      colorMap["forestgreen"] := "228b22"
      colorMap["gainsboro"] := "dcdcdc"
      colorMap["ghostwhite"] := "f8f8ff"
      colorMap["gold"] := "ffd700"
      colorMap["goldenrod"] := "daa520"
      colorMap["greenyellow"] := "adff2f"
      colorMap["grey"] := "808080"
      colorMap["honeydew"] := "f0fff0"
      colorMap["hotpink"] := "ff69b4"
      colorMap["indianred"] := "cd5c5c"
      colorMap["indigo"] := "4b0082"
      colorMap["ivory"] := "fffff0"
      colorMap["khaki"] := "f0e68c"
      colorMap["lavender"] := "e6e6fa"
      colorMap["lavenderblush"] := "fff0f5"
      colorMap["lawngreen"] := "7cfc00"
      colorMap["lemonchiffon"] := "fffacd"
      colorMap["lightblue"] := "add8e6"
      colorMap["lightcoral"] := "f08080"
      colorMap["lightcyan"] := "e0ffff"
      colorMap["lightgoldenrodyellow"] := "fafad2"
      colorMap["lightgray"] := "d3d3d3"
      colorMap["lightgreen"] := "90ee90"
      colorMap["lightgrey"] := "d3d3d3"
      colorMap["lightpink"] := "ffb6c1"
      colorMap["lightsalmon"] := "ffa07a"
      colorMap["lightseagreen"] := "20b2aa"
      colorMap["lightskyblue"] := "87cefa"
      colorMap["lightslategray"] := "778899"
      colorMap["lightslategrey"] := "778899"
      colorMap["lightsteelblue"] := "b0c4de"
      colorMap["lightyellow"] := "ffffe0"
      colorMap["limegreen"] := "32cd32"
      colorMap["linen"] := "faf0e6"
      colorMap["magenta"] := "ff00ff"
      colorMap["mediumaquamarine"] := "66cdaa"
      colorMap["mediumblue"] := "0000cd"
      colorMap["mediumorchid"] := "ba55d3"
      colorMap["mediumpurple"] := "9370db"
      colorMap["mediumseagreen"] := "3cb371"
      colorMap["mediumslateblue"] := "7b68ee"
      colorMap["mediumspringgreen"] := "00fa9a"
      colorMap["mediumturquoise"] := "48d1cc"
      colorMap["mediumvioletred"] := "c71585"
      colorMap["midnightblue"] := "191970"
      colorMap["mintcream"] := "f5fffa"
      colorMap["mistyrose"] := "ffe4e1"
      colorMap["moccasin"] := "ffe4b5"
      colorMap["navajowhite"] := "ffdead"
      colorMap["oldlace"] := "fdf5e6"
      colorMap["olivedrab"] := "6b8e23"
      colorMap["orangered"] := "ff4500"
      colorMap["orchid"] := "da70d6"
      colorMap["palegoldenrod"] := "eee8aa"
      colorMap["palegreen"] := "98fb98"
      colorMap["paleturquoise"] := "afeeee"
      colorMap["palevioletred"] := "db7093"
      colorMap["papayawhip"] := "ffefd5"
      colorMap["peachpuff"] := "ffdab9"
      colorMap["peru"] := "cd853f"
      colorMap["pink"] := "ffc0cb"
      colorMap["plum"] := "dda0dd"
      colorMap["powderblue"] := "b0e0e6"
      colorMap["rosybrown"] := "bc8f8f"
      colorMap["royalblue"] := "4169e1"
      colorMap["saddlebrown"] := "8b4513"
      colorMap["salmon"] := "fa8072"
      colorMap["sandybrown"] := "f4a460"
      colorMap["seagreen"] := "2e8b57"
      colorMap["seashell"] := "fff5ee"
      colorMap["sienna"] := "a0522d"
      colorMap["skyblue"] := "87ceeb"
      colorMap["slateblue"] := "6a5acd"
      colorMap["slategray"] := "708090"
      colorMap["slategrey"] := "708090"
      colorMap["snow"] := "fffafa"
      colorMap["springgreen"] := "00ff7f"
      colorMap["steelblue"] := "4682b4"
      colorMap["tan"] := "d2b48c"
      colorMap["thistle"] := "d8bfd8"
      colorMap["tomato"] := "ff6347"
      colorMap["turquoise"] := "40e0d0"
      colorMap["violet"] := "ee82ee"
      colorMap["wheat"] := "f5deb3"
      colorMap["whitesmoke"] := "f5f5f5"
      colorMap["yellowgreen"] := "9acd32"
      colorMap["rebeccapurple"] := "663399"
      return colorMap
    }
  }
  class Functor {
    /**
     * @param {any} context - Receiver or method name
     * @param {any[]} params*
     * @return {any}
     */
    __CALL(context, params*) {
      ; https://www.autohotkey.com/docs/objects/Functor.htm#User-Defined
      ; For %fn%() or fn.()
      if (context == "") {
        result := this.call(params*)
        return result
      }
      ; If this function object is being used as a method
      if (IsObject(context)) {
        result := this.call(context, params*)
        return result
      }
    }
    call() {
    }
  }
  class CaseSensitiveMap {
    _items_ := []
    /**
     * @param {any} [flatEntries*]
     */
    __NEW(flatEntries*) {
      this.set(flatEntries*)
    }
    _NEWENUM() {
      return this._items_._NEWENUM()
    }
    /**
     * @param {any} key
     * @return {boolean}
     */
    has(key) {
      codes := this._toCharCodes(key)
      return ObjHasKey(this._items_, codes)
    }
    /**
     * @param {any} keyOrValue
     * @return {boolean}
     */
    get(key, defaultValue := "") {
      if (this.has(key)) {
        key := this._toCharCodes(key)
        value := this._items_[key]
        return value
      }
      return defaultValue
    }
    /**
     * @param {any[]} [flatEntries*]
     */
    set(flatEntries*) {
      while (A_Index <= flatEntries.length() // 2) {
        key := flatEntries[(A_Index * 2) - 1]
        value := flatEntries[A_Index * 2]

        codes := this._toCharCodes(key)
        this._items_[codes] := value
      }
    }
    /**
     * @param {string} key
     * @return {string}
     */
    _toCharCodes(key) {
      if (IsObject(key)) {
        return key
      }

      charCodes := ""
      for i, char in StrSplit(key) {
        charCodes .= Asc(char)
      }
      return charCodes
    }
  }
  class Rect {
    ;; @type {number}
    x {
      get {
        x := this.pos1.x
        return x
      }
    }
    ;; @type {number}
    y {
      get {
        y := this.pos1.y
        return y
      }
    }
    points {
      get {
        points := [ [ this.x1, this.y1 ], [ this.x2, this.y2 ] ]
        return points
      }
    }
    ;; @type {number}
    x1 {
      get {
        return this.x
      }
    }
    ;; @type {number}
    y1 {
      get {
        return this.y
      }
    }
    ;; @type {number}
    x2 {
      get {
        x2 := this.pos2.x
        return x2
      }
    }
    ;; @type {number}
    y2 {
      get {
        y2 := this.pos2.y
        return y2
      }
    }
    ;; @type {number}
    width {
      get {
        width := this.x2 - this.x1
        return width
      }
    }
    ;; @type {number}
    w {
      get {
        return this.width
      }
    }
    ;; @type {number}
    height {
      get {
        height := this.y2 - this.y1
        return height
      }
    }
    ;; @type {number}
    h {
      get {
        return this.height
      }
    }
    /**
     * @param {number} x
     * @param {number} y
     * @param {number} width
     * @param {number} height
     * @param {number} [origin]
     */
    /**
     * @param {[ number, number, string ]} pos1
     * @param {[ number, number, string ]} pos2
     */
    /**
     * @param {{ x: number; y: number; origin: string }} pos1
     * @param {{ x: number; y: number; origin: string }} pos2
     */
    /**
     * @param {{
     *  | x: number;
     *  | y: number;
     *  | width: number; w: number;
     *  | height: number; h: number;
     *  | origin: string
     * }} rect
     */
    /**
     * @param {[ [ number, number, string ], [ number, number, string ] ]} rect
     */
    __NEW(params*) {
      if (4 <= params.length()) {
        x1 := params[1]
        y1 := params[2]
        x2 := x1 + params[3]
        y2 := y1 + params[4]
        origin := params[5]
        this.pos1 := CustomHotkey.Util.isNonEmpty(origin)
          ? new CustomHotkey.Util.Coordinates(x1, y1, origin)
          : { x: x1, y: y1 }
        this.pos2 := CustomHotkey.Util.isNonEmpty(origin)
          ? new CustomHotkey.Util.Coordinates(x2, y2, origin)
          : { x: x2, y: y2 }
      }
      else if (  params.length() == 2
              && CustomHotkey.Util.isArray(params[1])
              && CustomHotkey.Util.isArray(params[2]) ) {
        pos1 := params[1]
        pos2 := params[2]
        if (CustomHotkey.Util.isArray(pos1) && CustomHotkey.Util.isArray(pos1)) {
          x1 := pos1[1]
          y1 := pos1[2]
          origin1 := params[1][3]
          x2 := pos2[1]
          y2 := pos2[2]
          origin2 := params[2][3]
          this.pos1 := CustomHotkey.Util.isNonEmpty(origin1)
            ? new CustomHotkey.Util.Coordinates(x1, y1, origin1)
            : { x: x1, y: y1 }
          this.pos2 := CustomHotkey.Util.isNonEmpty(origin2)
            ? new CustomHotkey.Util.Coordinates(x2, y2, origin2)
            : { x: x2, y: y2 }
        }
        else {
          x1 := pos1.x
          y1 := pos1.y
          origin1 := pos1.origin
          x2 := pos2.x
          y2 := pos2.y
          origin2 := pos2.origin
          this.pos1 := CustomHotkey.Util.isNonEmpty(origin1)
            ? new CustomHotkey.Util.Coordinates(x1, y1, origin1)
            : { x: x1, y: y1 }
          this.pos2 := CustomHotkey.Util.isNonEmpty(origin2)
            ? new CustomHotkey.Util.Coordinates(x2, y2, origin2)
            : { x: x2, y: y2 }
        }
      }
      else if (params.length() == 1 && CustomHotkey.Util.isArray(params[1])) {
        rect := params[1]
        if (CustomHotkey.Util.isArray(rect[1])) {
          x1 := rect[1][1]
          y1 := rect[1][2]
          origin1 := CustomHotkey.Util.isNonEmptyField(rect[1], 3) ? rect[1][3] : defaultOrigin
          x2 := rect[2][1]
          y2 := rect[2][2]
          origin2 := CustomHotkey.Util.isNonEmptyField(rect[2], 3) ? rect[2][3] : defaultOrigin
          this.pos1 := CustomHotkey.Util.isNonEmpty(origin1)
            ? new CustomHotkey.Util.Coordinates(x1, y1, origin1)
            : { x: x1, y: y1 }
          this.pos2 := CustomHotkey.Util.isNonEmpty(origin2)
            ? new CustomHotkey.Util.Coordinates(x2, y2, origin2)
            : { x: x2, y: y2 }
        }
        else {
          x1 := rect[1].x
          y1 := rect[1].y
          origin1 := CustomHotkey.Util.isNonEmptyField(rect[1], "origin") ? rect[1].origin : defaultOrigin
          x2 := rect[2].x
          y2 := rect[2].y
          origin2 := CustomHotkey.Util.isNonEmptyField(rect[2], "origin") ? rect[2].origin : defaultOrigin

          this.pos1 := CustomHotkey.Util.isNonEmpty(origin1)
            ? new CustomHotkey.Util.Coordinates(x1, y1, origin1)
            : { x: x1, y: y1 }
          this.pos2 := CustomHotkey.Util.isNonEmpty(origin2)
            ? new CustomHotkey.Util.Coordinates(x2, y2, origin2)
            : { x: x2, y: y2 }
        }
      }
      else if (params.length() == 1 && IsObject(params[1])) {
        rect := params[1]
        x1 := rect.x
        y1 := rect.y
        x2 := x1 + (CustomHotkey.isNonEmpty(rect.width) ? rect.width : rect.w)
        y2 := y1 + (CustomHotkey.isNonEmpty(rect.height) ? rect.height : rect.h)
        origin := CustomHotkey.Util.isNonEmptyField(params, 5) ? params[5] : defaultOrigin

        this.pos1 := CustomHotkey.Util.isNonEmpty(origin)
          ? new CustomHotkey.Util.Coordinates(x1, y1, origin)
          : { x: x1, y: y1 }
        this.pos2 := CustomHotkey.Util.isNonEmpty(origin)
          ? new CustomHotkey.Util.Coordinates(x2, y2, origin)
          : { x: x2, y: y2 }
      }
      else {
        rectString := params[1]
        if (CustomHotkey.Util.equalsIgnoreCase(rectString, "window")) {
          this.pos1 := new CustomHotkey.Util.Coordinates(0, 0, "window-top-left")
          this.pos2 := new CustomHotkey.Util.Coordinates(0, 0, "window-bottom-right")
        }
        else if (CustomHotkey.Util.equalsIgnoreCase(rectString, "screen")) {
          this.pos1 := new CustomHotkey.Util.Coordinates(0, 0, "screen-top-left")
          this.pos2 := new CustomHotkey.Util.Coordinates(0, 0, "screen-bottom-right")
        }
      }
    }
    /**
     * @param {[ [ number, number ], [ number, number ] ]} rect
     * @return {boolean}
     */
    /**
     * @param {{ x1: number; y1: number; x2: number; y2: number }} rect
     * @return {boolean}
     */
    /**
     * @param {CustomHotkey.Util.Rect} rect
     * @return {boolean}
     */
    contains(rect) {
      if (CustomHotkey.Util.isArray(rect)) {
        rect := { x1: rect[1][1], y1: rect[1][2], x2: rect[2][1], y2: rect[2][1] }
      }
      if (  this.x1 <= rect.x1 && rect.x2 <= this.x2
        &&  this.y1 <= rect.y1 && rect.y2 <= this.y2 ) {
        return true
      }
      return false
    }
  }
}