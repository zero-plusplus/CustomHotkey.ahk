class Condition extends CustomHotkey.Util.Functor {
  ;; @type {CustomHotkey.ConditionBase[]}
  static _items := [ CustomHotkey.ImageCondition
                   , CustomHotkey.ImeCondition
                   , CustomHotkey.MouseTimeIdleCondition
                   , CustomHotkey.MousePositionCondition
                   , CustomHotkey.WindowCondition
                   , CustomHotkey.AndCondition
                   , CustomHotkey.OrCondition
                   , CustomHotkey.CustomCondition ]
  __NEW(data, isSingleKey := false) {
    this.data := data
    this.condition := CustomHotkey.Condition.create(data)
    this.isSingleKey := isSingleKey
  }
  /**
   * Add a Condition.
   * @param {CustomHotkey.ConditionBase} condition
   * @chainable
   */
  /**
   * Add a Condition to the specified index.
   *
   * If there is a conflict in the definition of Condition Data, the Condition with the lower index will take precedence.
   * @param {number} index
   * @param {CustomHotkey.ConditionBase} condition
   * @chainable
   */
  add(params*) {
    if (params.length() == 2) {
      index := params[1]
      condition := params[2]
      this._items.insertAt(index, condition)
      return this
    }

    this._items.insertAt(1, params[1])
    return this
  }
  /**
   * Get the Condition class linked to the Condition Data.
   * @static
   * @param {any | CustomHotkey.ConditionBase} data
   * @return {CustomHotkey.ConditionBase}
   */
  get(data) {
    for i, condition in this._items {
      if (condition.isConditionData(data)) {
        return condition
      }
    }
  }
  /**
   * Create an instance of the Condition linked to the Condition Data.
   * @static
   * @param {any} data
   * @return {CustomHotkey.ConditionBase}
   */
  create(data, params*) {
    if (CustomHotkey.Util.instanceof(data, CustomHotkey.ConditionBase)) {
      return data
    }

    condition := this.get(data)
    return new condition(data, params*)
  }
  /**
   * Execute a Condition linked to the Condition Data.
   * @static
   * @param {any} data
   * @param {any[]} [params*]
   * @return {any}
   */
  execute(data, params*) {
    condition := CustomHotkey.Util.instanceof(data, CustomHotkey.ConditionBase)
      ? data
      : CustomHotkey.Condition.create(data)
    restorer := CustomHotkey.logger.tempSetEnabled(CustomHotkey.debugOptions.enableConditionLog)

    conditionName := StrSplit(condition.__CLASS, ".").pop()
    startTime_ms := A_TickCount
    result := CustomHotkey.Util.invoke(condition, params*)
    elapsedTime_ms := A_TickCount - startTime_ms
    if (result) {
      CustomHotkey.logger.log("Matched {} from <{}> in {} ms.", conditionName, A_ThisHotkey, elapsedTime_ms)
    }

    %restorer%()
    return result
  }
  /**
   * Execute the Condition.
   */
  call() {
    result := CustomHotkey.Condition.execute(this.condition)
    return result
  }
}