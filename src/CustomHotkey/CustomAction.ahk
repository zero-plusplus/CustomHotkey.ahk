class CustomAction extends CustomHotkey.ActionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return CustomHotkey.Util.isCallable(data)
  }
  /**
   * Execute the Action.
   * @param {any[]} [params*]
   * @return {any}
   */
  call(params*) {
    return CustomHotkey.Util.invoke(this.data, params*)
  }
}