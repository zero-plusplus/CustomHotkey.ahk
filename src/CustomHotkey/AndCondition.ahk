class AndCondition extends CustomHotkey.ConditionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return IsObject(data) && ObjHasKey(data, "and")
  }
  /**
   * Execute the Condition.
   * @return {boolean}
   */
  call() {
    data := this.data
    conditions := data.and

    for i, condition in conditions {
      if (!CustomHotkey.Condition.execute(condition)) {
        return false
      }
    }
    return true
  }
}