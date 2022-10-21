class CustomCondition extends CustomHotkey.ConditionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isConditionData(data) {
    return CustomHotkey.Util.isCallable(data)
  }
  /**
   * Execute the Condition.
   * @return {boolean}
   */
  call() {
    return CustomHotkey.Util.invoke(this.data, new CustomHotkey.Util.WindowInfo("A"))
  }
}