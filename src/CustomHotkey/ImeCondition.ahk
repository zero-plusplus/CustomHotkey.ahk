class ImeCondition extends CustomHotkey.ConditionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return IsObject(data) && ObjHasKey(data, "ime")
  }
  /**
   * Execute the Condition.
   * @return {boolean}
   */
  call() {
    return CustomHotkey.Util.Ime.status == this.data.ime
  }
}