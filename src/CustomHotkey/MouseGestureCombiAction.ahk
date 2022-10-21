class MouseGestureCombiAction extends CustomHotkey.ActionBase {
  static defaultOptions := { tip: { x: 0
                                  , y: 0
                                  , origin: ""
                                  , id: ""
                                  , labels: { "LButton": [ "L", "𝐋" ]
                                            , "RButton": [ "R", "𝐑" ]
                                            , "MButton": [ "M", "𝐌" ]
                                            , "XButton1": [ "X1", "𝐗𝟭" ]
                                            , "XButton2": [ "X2", "𝐗𝟮" ]
                                            , "MoveUp": [ "🡡", "🢁" ]
                                            , "MoveDown": [ "🡣", "🢃" ]
                                            , "MoveLeft": [ "🡠", "🢀" ]
                                            , "MoveRight": [ "🡢", "🢂" ]
                                            , "MoveUpLeft": [ "🡤", "🢄" ]
                                            , "MoveUpRight": [ "🡥", "🢅" ]
                                            , "MoveDownLeft": [ "🡧", "🢇" ]
                                            , "MoveDownRight": [ "🡦", "🢇" ] } }
                           , threshold: 50
                           , style: { width: 6, color: "lime" } }
  static guiTitle := "CustomHotkey" . &CustomHotkey.MouseGestureCombiAction
  static gestureLabelMap := { "LButton": [ "Left", "L" ]
                            , "RButton": [ "Right", "R" ]
                            , "MButton": [ "Middle", "M" ]
                            , "XButton1": [ "X1" ]
                            , "XButton2": [ "X2" ]
                            , "WheelUp": [ "WU" ]
                            , "WheelDown": [ "WD" ]
                            , "WheelLeft": [ "WL" ]
                            , "WheelRight": [ "WR" ]
                            , "MoveUp": [ "MU", "↑", "🡡", "🡩", "🡱", "🡹", "🢁" ]
                            , "MoveDown": [ "MD", "↓", "🡣", "🡫", "🡳", "🡻", "🢃" ]
                            , "MoveLeft": [ "ML", "←", "🡠", "🡨", "🡰", "🡸", "🢀" ]
                            , "MoveRight": [ "MR", "→", "🡢", "🡪", "🡲", "🡺", "🢂" ]
                            , "MoveUpLeft": [ "MUL", "↖", "🡤", "🡬", "🡴", "🡼", "🢄" ]
                            , "MoveUpRight": [ "MUR", "↗", "🡥", "🡭", "🡵", "🡽", "🢅" ]
                            , "MoveDownLeft": [ "MDL", "↙", "🡧", "🡯", "🡷", "🡿", "🢇" ]
                            , "MoveDownRight": [ "MDR", "↘", "🡦", "🡮", "🡶", "🡾", "🢆" ] }
  guiName {
    get {
      return "Base" . &this
    }
  }
  canvasName {
    get {
      return "Canvas" . &this
    }
  }
  /**
   * @static
   * @return {boolean}
   */
  isActionData(data) {
    if (IsObject(data) && ObjHasKey(data, "items")) {
      data := data.items
    }
    if (!CustomHotkey.Util.isArray(data)) {
      return false
    }

    for i, item in data {
      if (IsObject(item) && ObjHasKey(item, "gestures")) {
        continue
      }
      return false
    }
    return true
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.MouseGestureCombiAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (CustomHotkey.Util.isArray(data)) {
      data := { items: data }
    }
    normalized := this.setDefaultOptions(data)

    rgb := new CustomHotkey.Util.RGB(normalized.style.color)
    normalized.style.color := "0x" . rgb.b . rgb.g . rgb.r
    for i, item in normalized.items {
      normalized.items[i] := this.normalizeActionItem(item)
    }
    return normalized
  }
  /**
   * @static
   * @param {any} item
   * @return {{ gestures: string[]; description: string; action: callable }}
   */
  normalizeActionItem(item) {
    normalized := this.setDefaultOptions(item, {})
    normalized.gestures := []
    for i, gesture in item.gestures {
      normalized.gestures.push(this.normalizeGesture(gesture))
    }
    normalized.description := item.desc
    if (item.description) {
      normalized.description := item.description
    }
    normalized.action := item.action
    return normalized
  }
  /**
   * @static
   * @param {string} gesture
   * @return {string}
   */
  normalizeGesture(gesture) {
    for label, aliases in CustomHotkey.MouseGestureCombiAction.gestureLabelMap {
      for i, aliase in aliases {
        if (gesture ~= "i)^" aliase "$") {
          return label
        }
      }
    }
    return gesture
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    trigger := new CustomHotkey.Trigger(data.targetKey != "" ? data.targetKey : A_ThisHotkey)
    this.executeAction({ holding: ObjBindMethod(this, "onHolding")
                       , hold: ObjBindMethod(this, "onHold")
                       , targetKey: trigger.key
                       , release: ObjBindMethod(this, "onRelease")
                       , repeatInterval: "16.666ms" })
  }
  /**
   * @private
   * @param {{ x: number, y: number }} startPosition
   * @param {{ x: number, y: number }} currentPosition
   * @param {number} threshold
   * @param {string[]} targetGestures
   * @return {string}
   */
  _checkMoveDirection(startPosition, currentPosition, threshold, targetGestures) {
    threshold_half := threshold / 2
    diff_x_half := CustomHotkey.Util.clampNumber(currentPosition.x - startPosition.x, -threshold_half, threshold_half)
    diff_y_half := CustomHotkey.Util.clampNumber(currentPosition.y - startPosition.y, -threshold_half, threshold_half)

    if (diff_x_half == -threshold_half && diff_y_half == -threshold_half) {
      if (!CustomHotkey.Util.includesArray(targetGestures, "MoveUpLeft")) {
        if (CustomHotkey.Util.includesArray(targetGestures, "MoveUp") && Abs(diff_x_half) <= Abs(diff_y_half)) {
          return "MoveUp"
        }
        return "MoveLeft"
      }
      return "MoveUpLeft"
    }
    if (diff_x_half == threshold_half && diff_y_half == -threshold_half) {
      if (!CustomHotkey.Util.includesArray(targetGestures, "MoveUpRight")) {
        if (CustomHotkey.Util.includesArray(targetGestures, "MoveUp") && Abs(diff_x_half) <= Abs(diff_y_half)) {
          return "MoveUp"
        }
        return "MoveRight"
      }
      return "MoveUpRight"
    }
    if (diff_x_half == -threshold_half && diff_y_half == threshold_half) {
      if (!CustomHotkey.Util.includesArray(targetGestures, "MoveDownLeft")) {
        if (CustomHotkey.Util.includesArray(targetGestures, "MoveDown") && Abs(diff_x_half) <= Abs(diff_y_half)) {
          return "MoveDown"
        }
        return "MoveLeft"
      }
      return "MoveDownLeft"
    }
    if (diff_x_half == threshold_half && diff_y_half == threshold_half) {
      if (!CustomHotkey.Util.includesArray(targetGestures, "MoveDownRight")) {
        if (CustomHotkey.Util.includesArray(targetGestures, "MoveDown") && Abs(diff_x_half) <= Abs(diff_y_half)) {
          return "MoveDown"
        }
        return "MoveRight"
      }
      return "MoveDownRight"
    }

    diff_x := CustomHotkey.Util.clampNumber(currentPosition.x - startPosition.x, -threshold, threshold)
    diff_y := CustomHotkey.Util.clampNumber(currentPosition.y - startPosition.y, -threshold, threshold)
    if (-diff_y == threshold) {
      return "MoveUp"
    }
    if (diff_y == threshold) {
      return "MoveDown"
    }
    if (-diff_x == threshold) {
      return "MoveLeft"
    }
    if (diff_x == threshold) {
      return "MoveRight"
    }
  }
  /**
   * @private
   * @return {string}
   */
  _getPressedMouseButton() {
    if (GetKeyState("LButton", "P")) {
      return "LButton"
    }
    if (GetKeyState("RButton", "P")) {
      return "RButton"
    }
    if (GetKeyState("MButton", "P")) {
      return "MButton"
    }
    if (GetKeyState("XButton1", "P")) {
      return "XButton1"
    }
    if (GetKeyState("XButton2", "P")) {
      return "XButton2"
    }
  }
  /**
   * @private
   * @param {{ x: number; y: number }} from
   * @param {{ x: number; y: number }} to
   * @param {{ color: string }} style
   */
  _drawLine(from, to, style) {
    static PS_SOLID := 0x00

    deviceContext := DllCall("GetDC", "UInt", this.hwnd) ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getdc
    pen := DllCall("CreatePen", "UInt", 0, "UInt", style.width, "UInt", style.color) ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createpen
    DllCall("SelectObject", "UInt", deviceContext, "UInt", pen) ; ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-selectobject
    DllCall("gdi32.dll\MoveToEx", "UInt", deviceContext, "Uint", from.x, "UInt", from.y, "UInt", lppt := 0) ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-movetoex
    DllCall("gdi32.dll\LineTo", "UInt", deviceContext, "Uint", to.x, "UInt", to.y) ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-lineto
    DllCall("ReleaseDC", "UInt", hwnd, "UInt", deviceContext) ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-releasedc
    DllCall("DeleteObject", "UInt", pen) ; https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-deleteobject
  }
  /**
   * @private
   * @param {Array<{ gestures: string[]; description: string; action: any }>} items
   * @param {string[]} matchedGestures
   * @return {Array<{ gestures: string[]; description: string; action: any }>}
   */
  _filter(items, matchedGestures) {
    if (matchedGestures.length() == 0) {
      return items
    }

    filtered := []
    for i, item in items {
      slicedGestures := CustomHotkey.Util.sliceArray(item.gestures, 1, matchedGestures.length())
      if (!CustomHotkey.Util.deepEquals(slicedGestures, matchedGestures)) {
        continue
      }
      filtered.push(item)
    }
    return filtered
  }
  /**
   * @event
   */
  onHolding() {
    data := this.data

    this.context := {}
    this.context.trigger := new CustomHotkey.Trigger(A_ThisHotkey)

    baseColor := 0x000000 ; new CustomHotkey.Util.RGB(data.style.color).invert().hex

    ; Prepare two windows, one for the user block and one for the canvas.
    ; Because `WinSet, TransColor` also makes user input transparent.
    Gui, % this.guiName ":+LastFound +ToolWindow -Caption"
    Gui, % this.guiName ":Color", % baseColor
    WinSet, Transparent, 1
    Gui, % this.guiName ":Show", Maximize, % CustomHotkey.MouseGestureCombiAction.guiTitle

    Gui, % this.canvasName ":+LastFound +ToolWindow -Caption"
    Gui, % this.canvasName ":Color", % baseColor
    WinSet, TransColor, %baseColor%
    Gui, % this.canvasName ":Show", Maximize, % CustomHotkey.MouseGestureCombiAction.guiTitle

    textColor := new CustomHotkey.Util.RGB(data.style.color).hex
    this.hwnd := WinExist()

    this.context.tip := new CustomHotkey.Util.ToolTip(data.tip.id)
    this.context.initPosition := new CustomHotkey.Util.Coordinates(0, 0, "mouse")
    this.context.startPosition := this.context.initPosition
    this.context.currentPosition := this.context.startPosition
    this.context.matchedGestures := []
    this.context.startTime_ms := A_TickCount
    return this.context
  }
  /**
   * @event
   */
  onHold(context, done) {
    data := this.data

    items := this._filter(data.items, context.matchedGestures)
    message := ""
    for i, item in items {
      for i, gesture in item.gestures {
        message .= (context.matchedGestures[i] == gesture)
          ? "【 " . data.tip.labels[gesture][2] . " 】"
          : " [ " . data.tip.labels[gesture][1] . " ] "
      }

      if (item.description) {
        message .= " : " . item.description
      }
      message .= "`n"
    }
    message := RTrim(message, "`n")
    context.tip.show(message, { x: context.initPosition.x + 10, y: context.initPosition.y + 15, origin: "screen" })

    newPosition := new CustomHotkey.Util.Coordinates(0, 0, "mouse")
    this._drawLine(context.currentPosition, newPosition, data.style)

    gesture := ""
    moveDirection := ""

    pressedMouseButton := this._getPressedMouseButton()
    if (pressedMouseButton && !CustomHotkey.Util.equalsIgnoreCase(this.context.trigger.key, pressedMouseButton)) {
      gesture := pressedMouseButton
      context.startPosition := newPosition
      CustomHotkey.Util.waitReleaseKey(pressedMouseButton)
    }
    else {
      moveDirection := this._checkMoveDirection(context.startPosition, newPosition, data.threshold, targetGestures)
      if (!gesture && moveDirection) {
        gesture := moveDirection
        context.startPosition := newPosition
      }
    }

    matchedGesture := ""
    if (gesture) {
      for i, item in items {
        targetGesture := item.gestures[context.matchedGestures.length() + 1]
        if (targetGesture == gesture) {
          matchedGesture := gesture
          break
        }
      }
    }

    if (matchedGesture) {
      context.matchedGestures.push(gesture)
    }
    if (CustomHotkey.Util.deepEqualsIgnoreCase(item.gestures, context.matchedGestures)) {
      context.matchedItem := item
      return done
    }

    context.currentPosition := newPosition
    return context
  }
  /**
   * @event
   */
  onRelease(context, isDone) {
    Gui, % this.guiName ":Destroy"
    Gui, % this.canvasName ":Destroy"
    context.tip.close()

    if (context.matchedItem) {
      this.executeAction(context.matchedItem.action)
    }
    else {
      context.tip.show(isDone ? "Force terminate" : "Cancel", { x: context.initPosition.x, y: context.initPosition.y, origin: "screen", displayTime: "0.6s" })
    }
    context.trigger.waitRelease()
  }
  /**
   * @event
   */
  onExecuting() {
  }
  /**
   * @event
   */
  onExecuted() {
    this.context.tip.close()
    Gui, % this.guiName ":Destroy"
    Gui, % this.canvasName ":Destroy"
  }
}