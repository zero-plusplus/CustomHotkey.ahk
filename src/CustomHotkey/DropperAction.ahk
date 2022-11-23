class DropperAction extends CustomHotkey.ActionBase {
  static defaultOptions := { dropper: "color"
                           , targetKey: ""
                           , options: ""
                           , tip: { id: "", x: 0, y: 0, origin: "", delay: "100ms" } }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && ObjHasKey(data, "dropper")
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.DropperAction.defaultOptions}
   */
  normalizeActionData(data) {
    data := this.setDefaultOptions(data)
    if (!IsObject(data.dropper) || CustomHotkey.Util.isCallable(data.dropper)) {
      data.dropper := ObjBindMethod(CustomHotkey.DropperAction.DefaultMethods, "wrapTargetMethod", data.dropper)
    }
    if (CustomHotkey.Util.instanceOf(this.prevAction, CustomHotkey.KeyStrokeCombiAction)) {
      data.targetKey := this.prevAction.context.input
    }
    data.delay := CustomHotkey.Util.timeunit(data.delay, "ms")
    return data
  }
  /**
   * Executes the action.
   */
  call() {
    data := this.data

    this.context := { startTime_ms: A_TickCount
                    , tip: new CustomHotkey.Util.ToolTip(data.tip.id)
                    , trigger: new CustomHotkey.Trigger(data.targetKey != "" ? data.targetKey : A_ThisHotkey) }

    targetKey := this.context.trigger.key
    if (CustomHotkey.Util.instanceof(this.prevAction, CustomHotkey.KeyStrokeCombiAction)) {
      targetKey := this.prevAction.context.input
    }
    this.executeAction({ hold: ObjBindMethod(this, "onHold")
                       , targetKey: targetKey
                       , release: ObjBindMethod(this, "onRelease")
                       , repeatInterval: "16.666ms" })
  }
  /**
   * @event
   */
  onHold() {
    data := this.data

    result := CustomHotkey.Util.invoke(data.dropper, data.options)
    elapsedTime_ms := A_TickCount - this.context.startTime_ms
    if (result && delay_ms < elapsedTime_ms) {
      this.context.tip.show(result, data.tip)
    }
    return result
  }
  /**
   * @event
   */
  onRelease(result) {
    if (!IsObject(result)) {
      Clipboard := result
    }
    CustomHotkey.Util.blockUserInput(false)
    this.context.tip.close()
  }
  /**
   * @event
   */
  onExecuted() {
    this.context.tip.close()
  }
  class DefaultMethods {
    /**
     * @static
     * @param {{ x: number, y: number }} position
     * @param {string | { template: string, method: "default" | "alt" | "slow" }} options
     * @return {string}
     */
    color(position, options) {
      options := IsObject(options) ? options : { template: options }
      template := options.template ? options.template : "#{r:X}{g:X}{b:X}"
      mode := options.method ? options.method : "Default"
      if (mode ~= "i)^Default$") {
        mode := ""
      }

      PixelGetColor color, % position.x, % position.y, %mode% RGB
      rgb := StrReplace(color, "0x")
      r := Format("{:d}", "0x" . SubStr(rgb, 1, 2))
      g := Format("{:d}", "0x" . SubStr(rgb, 3, 2))
      b := Format("{:d}", "0x" . SubStr(rgb, 5, 2))
      return CustomHotkey.Util.templateString(template, { r: r, g: g, b: b })
    }
    /**
     * @static
     * @param {{ x: number, y: number }} position
     * @param {string | { template: string, origin: string }} options
     * @return {string}
     */
    coordinates(position, options) {
      options := IsObject(options) ? options : { template: options }
      template := options.template ? options.template : "{x}, {y}"
      origin := options.origin ? options.origin : "monitors"

      originPosition := new CustomHotkey.Util.Coordinates(0, 0, origin)
      x := position.x - originPosition.x
      y := position.y - originPosition.y
      return CustomHotkey.Util.templateString(template, { x: x, y: y })
    }
    /**
     * @alias coordinates
     */
    coord(position, options) {
      return this.coordinates(position, options)
    }
    /**
     * @static
     * @param {{ x: number, y: number }} position
     * @param {string | { template: string }} options
     * @return {string}
     */
    window(position, options) {
      options := IsObject(options) ? options : { template: options }
      template := options.template ? options.template : "title: {title}`nclass: {ahk_class}`nexe: {ahk_exe}`npath: {path}`nid: {ahk_id}`npid: {ahk_pid}`ncontrolName: {controlName}`ncontrolId: {controlId}"

      MouseGetPos, , , hwnd, ctrl
      MouseGetPos, , , , ctrlHwnd, 2
      WinGetTitle, winTitle, ahk_id %hwnd%, , ahk_exe %A_AhkPath%
      WinGetClass, winClass, ahk_id %hwnd%, , ahk_exe %A_AhkPath%
      WinGet, winExe, ProcessName, ahk_id %hwnd%, , ahk_exe %A_AhkPath%
      WinGet, winExePath, ProcessPath, ahk_id %hwnd%, , ahk_exe %A_AhkPath%
      WinGet, winId, ID, ahk_id %hwnd%, , ahk_exe %A_AhkPath%
      WinGet, winPid, PID, ahk_id %hwnd%, , ahk_exe %A_AhkPath%
      if (winClass == "tooltips_class32") {
        return ""
      }
      info := CustomHotkey.Util.templateString(template, { title: winTitle
                                                         , class: winClass
                                                         , ahk_class: "ahk_class " winClass
                                                         , exe: winExe
                                                         , ahk_exe: "ahk_exe " winExe
                                                         , path: winExePath
                                                         , id: winId
                                                         , hwnd: winId
                                                         , ahk_id: "ahk_id " winId
                                                         , pid: winPid
                                                         , ahk_pid: "ahk_pid " winPid
                                                         , controlName: ctrl
                                                         , controlId: ctrlHwnd
                                                         , controlHwnd: ctrlHwnd })
      return info
    }
    /**
     * @static
     * @param {callable} method
     * @param {{ x: number, y: number }} position
     * @param {any} options
     * @return {string}
     */
    custom(method, position, options) {
      return CustomHotkey.Util.invoke(method, position, options)
    }
    /**
     * @static
     * @param {callable} method
     * @param {{ x: number, y: number }} position
     * @param {any} options
     * @return {string}
     */
    wrapTargetMethod(method, options) {
      position := new CustomHotkey.Util.Coordinates(0, 0, "mouse")
      if (!IsObject(method) && method ~= "i)(color|coord(inates)?|window)") {
        return CustomHotkey.Util.invoke(ObjBindMethod(this, method), position, options)
      }
      return CustomHotkey.Util.invoke(ObjBindMethod(this, "custom", method), position, options)
    }
  }
}