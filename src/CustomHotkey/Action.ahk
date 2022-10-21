class Action extends CustomHotkey.Util.Functor {
  /**
   * @private
   * @type {CustomHotkey.ActionBase[]}
   */
  static _items := [ CustomHotkey.AsyncAction
                   , CustomHotkey.DelayAction
                   , CustomHotkey.PasteAction
                   , CustomHotkey.ToolTipAction
                   , CustomHotkey.TrayTipAction
                   , CustomHotkey.ExitAction
                   , CustomHotkey.ExitAllAction
                   , CustomHotkey.ReloadAction
                   , CustomHotkey.RunAction
                   , CustomHotkey.SendAction
                   , CustomHotkey.DropperAction
                   , CustomHotkey.ImeAction
                   , CustomHotkey.MouseGestureCombiAction
                   , CustomHotkey.TernaryCombiAction
                   , CustomHotkey.ContextMenuCombiAction
                   , CustomHotkey.ImageClickAction
                   , CustomHotkey.MouseDragAction
                   , CustomHotkey.MouseClickAction
                   , CustomHotkey.MouseMoveAction
                   , CustomHotkey.CustomAction
                   , CustomHotkey.CommandPaletteCombiAction
                   , CustomHotkey.KeyStrokeCombiAction
                   , CustomHotkey.PressEventCombiAction
                   , CustomHotkey.HoldEventCombiAction
                   , CustomHotkey.ModifierPressCombiAction
                   , CustomHotkey.ConditionCombiAction
                   , CustomHotkey.ExtraPressCombiAction
                   , CustomHotkey.CustomActions ]
  /**
   * @param {any} data
   */
  __NEW(data, hotkey) {
    this.data := data
    this.action := CustomHotkey.Action.create(data)
    this.hotkey := hotkey
  }
  /**
   * Add an Action.
   * @param {CustomHotkey.ActionBase} action
   * @chainable
   */
  /**
   * Add an Action to the specified index.
   *
   * If there is a conflict in the definition of Action data, the Action with the lower index will take precedence.
   * @param {number} index
   * @param {CustomHotkey.ActionBase} action
   * @chainable
   */
  add(params*) {
    if (params.length() == 2) {
      index := params[1]
      action := params[2]
      this._items.insertAt(index, action)
      return this
    }

    this._items.insertAt(1, params[1])
    return this
  }
  /**
   * Get a Action class linked to a Action Data.
   * @static
   * @param {any | CustomHotkey.ActionBase} data
   * @return {CustomHotkey.ActionBase}
   */
  get(data) {
    for i, action in this._items {
      if (action.isActionData(data)) {
        return action
      }
    }
  }
  /**
   * Create an instance of the Action linked to the Action Data.
   * @static
   * @param {any} data
   * @param {CustomHotkey.ActionBase} prevAction
   * @return {CustomHotkey.ActionBase}
   */
  create(data, prevAction := "") {
    if (CustomHotkey.Util.instanceof(data, CustomHotkey.ActionBase)) {
      return data
    }

    action := this.get(data)
    return new action(data, prevAction)
  }
  /**
   * Execute an Action linked to the Action Data.
   * @static
   * @param {any} data
   * @param {any[]} [params*]
   * @return {any}
   */
  execute(data, params*) {
    restorer_log := CustomHotkey.logger.tempSetEnabled(CustomHotkey.debugOptions.enableActionLog)

    settings := ""
    startTime_ms := 0
    try {
      action := CustomHotkey.Util.instanceof(data, CustomHotkey.ActionBase) ? data : this.create(data)
      action.context := ""
      settings := action.onExecuting()
      actionName := StrSplit(action.__CLASS, ".").pop()
      CustomHotkey.logger.log("Starting {} (id: {}).{}", actionName, &action, extraInfo).indent()

      startTime_ms := A_TickCount
      result := CustomHotkey.Util.invoke(action, params*)
      return result
    }
    finally {
      try {
        action.onExecuted(settings)
      }
      finally {
        elapsedTime_ms := A_TickCount - startTime_ms
        CustomHotkey.logger.dedent().log("Finished {} (id: {}) in {} ms.", actionName, &action, elapsedTime_ms)
      }
    }
  }
  /**
   * Execute an action.
   */
  call() {
    startTime_ms := 0
    try {
      trigger := this.hotkey.trigger.raw
      restorer_log := CustomHotkey.logger.tempSetEnabled(CustomHotkey.debugOptions.enableActionLog)
      CustomHotkey.logger.log("Starting Action from <{}>)", trigger).indent()

      startTime_ms := A_TickCount
      result := CustomHotkey.Action.execute(this.action)
      return result
    }
    catch e {
      CustomHotkey.logger.log("[ERROR] {} {}:{}", action.__Class, e.file, e.line)
      CustomHotkey.logger.indent().log("> {}", e.message).dedent()
    }
    finally {
      elapsedTime_ms := A_TickCount - startTime_ms
      CustomHotkey.logger.dedent().log("Finished Action from <{}> in {} ms", trigger, elapsedTime_ms)
      %restorer_log%()

      CustomHotkey.Util.blockUserInput(false)
    }
  }
}