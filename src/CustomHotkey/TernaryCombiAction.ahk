class TernaryCombiAction extends CustomHotkey.ActionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && ObjHasKey(data, "condition") && (ObjHasKey(data, "action") || ObjHasKey(data, "altAction"))
  }
  /**
   * Execute the Action.
   */
  call() {
    data := this.data
    result := CustomHotkey.Condition.execute(data.condition)
    return this.executeAction(result ? data.action : data.altAction)
  }
}