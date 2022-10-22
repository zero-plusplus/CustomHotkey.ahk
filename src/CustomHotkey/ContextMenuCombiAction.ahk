class ContextMenuCombiAction extends CustomHotkey.ActionBase {
  static defaultOptions := { x: 0
                           , y: 0
                           , origin: "" }
  menuName {
    get {
      return this.__Class ":" &this
    }
  }
  shouldRestore := true
  isCreatedMenu := false
  childMenuNames := []
  /**
   * Destraction the Action.
   */
  __DELETE() {
    this.close()
  }
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    if (IsObject(data) && ObjHasKey(data, "items")) {
      data := data.items
    }
    if (!CustomHotkey.Util.isArray(data)) {
      return false
    }

    result := false
    for i, item in data {
      if (InStr(item, "-") || InStr(item, "=")) {
        continue
      }
      if (IsObject(item) && ObjHasKey(item, "label")) {
        result := true
        continue
      }
      return false
    }
    return result
  }
  /**
   * @static
   * @param {any} data
   * @return {CustomHotkey.ContextMenuCombiAction.defaultOptions}
   */
  normalizeActionData(data) {
    if (CustomHotkey.Util.isArray(data)) {
      data := { items: data }
    }

    data := this.setDefaultOptions(data)
    for i, item in data.items {
      data.items[i] := IsObject(item) ? item : { label: "", action: "" }
    }
    return data
  }
  /**
   * @static
   * @param {any} item
   */
  setChildItem(item) {
    if (CustomHotkey.Util.isNonEmpty(item.condition) && !CustomHotkey.Condition.execute(item.condition)) {
      return
    }

    actionOrMenu := ""
    if (CustomHotkey.ContextMenuCombiAction.isActionData(item.action)) {
      childItem := new CustomHotkey.ContextMenuCombiAction(item.action, this)
      childItem.setChildItems(childItem.data.items)
      actionOrMenu := ":" childItem.menuName
      this.childMenuNames.push(childItem)
    }
    else if (CustomHotkey.Util.instanceof(item.action, CustomHotkey.ContextMenuCombiAction)) {
      actionOrMenu := ":" item.action.menuName
      childItem.setChildItems(item.action.data.items)
      this.childMenuNames.push(childItem.menuName)
    }
    else {
      actionOrMenu := ObjBindMethod(CustomHotkey.Action, "execute", item.action)
      this.childMenuNames.push(item.label)
    }

    if (CustomHotkey.Util.isNonEmpty(item.label)) {
      Menu % this.menuName, Add, % item.label, %actionOrMenu%
      return
    }
    ; Add separator line
    Menu, % this.menuName, Add
  }
  /**
   * @static
   * @param {any[]} items
   */
  setChildItems(items) {
    for i, item in items {
      this.setChildItem(items[i])
    }
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data

    this.setChildItems(data.items)
    if (this.childMenuNames.length() == 0) {
      return
    }

    position := new CustomHotkey.Util.Coordinates(data.x, data.y, data.origin)
    Menu, % this.menuName, Show, % position.x, % position.y
    this.isCreatedMenu := true
    if (GetKeyState("Escape", "P") && this.prevAction) {
      this.restoreAction()
    }
  }
  /**
   * Close the context menu.
   */
  close() {
    if (!this.prevAction) {
      for i, childMenuItem in this.childMenuNames {
        if (CustomHotkey.Util.instanceof(childItem, CustomHotkey.ContextMenuCombiAction)) {
          this.close()
          continue
        }
      }
      if (this.isCreatedMenu) {
        Menu, % this.menuName, Delete
      }
    }
  }
  /**
   * @event
   */
  onExecuted() {
    this.close()
  }
}