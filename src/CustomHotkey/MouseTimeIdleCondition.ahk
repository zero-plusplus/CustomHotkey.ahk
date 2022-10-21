class MouseTimeIdleCondition extends CustomHotkey.ConditionBase {
  static defaultOptions := { mouseTimeIdle: "1s" }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return IsObject(data) && ObjHasKey(data, "mouseTimeIdle")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ConditionBase.defaultOptions}
   */
  normalizeConditionData(data) {
    data := this.setDefaultOptions(data)
    data.mouseTimeIdle := CustomHotkey.Util.timeunit(data.mouseTimeIdle, "ms")
    return data
  }
  /**
   * Execute the Condition.
   * @return {boolean}
   */
  call() {
    static enabled := false, startTime_ms := 0

    enabled := A_TimeIdleMouse <= this.data.mouseTimeIdle
    if (enabled) {
      startTime_ms := A_TickCount
      return true
    }

    ; Avoid the problem that holding down the hotkey trigger for this Condition causes the default hotkey to be executed when it times out
    elapsedTime_ms := A_TickCount - startTime_ms
    if (elapsedTime_ms < 300) {
      startTime_ms := A_TickCount
      return true
    }

    startTime_ms := 0
    return false
  }
}
