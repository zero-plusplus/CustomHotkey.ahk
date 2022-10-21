#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

CustomHotkey.Condition.add(UserCondition)
new CustomHotkey("RCtrl & 1", "{ToolTip}Logon " . A_UserName, { user: A_UserName }).on()
new CustomHotkey("RCtrl & 2", "{ToolTip}Logon user_b", { user: "user_b" }).on()
new CustomHotkey("RCtrl & 2", "{ToolTip}user_b is not login").on()

class UserCondition extends CustomHotkey.ConditionBase {
  isConditionData(data) {
    return IsObject(data) && ObjHasKey(data, "user")
  }
  call() {
    return this.data.user == A_UserName
  }
}
