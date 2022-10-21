class OrCondition extends CustomHotkey.ConditionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return IsObject(data) && ObjHasKey(data, "or")
  }
  /**
   * Execute the Condition.
   * @return {boolean}
   */
  call() {
    data := this.data
    conditions := data.or

    for i, condition in conditions {
      if (CustomHotkey.Condition.execute(condition)) {
        return true
      }
    }
    return false
  }
}