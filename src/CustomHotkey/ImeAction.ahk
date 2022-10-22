class ImeAction extends CustomHotkey.ActionBase {
  /**
   * @static
   * @param {any} data
   * @return {boolean}
   */
  isActionData(data) {
    return IsObject(data) && ObjHasKey(data, "ime")
  }
  /**
   * Execute the Action.
   */
  call() {
    CustomHotkey.Util.Ime.setStatus(this.data.ime)
  }
}