#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

CustomHotkey.Action.add(CommandPromptAction)
new CustomHotkey("RCtrl & 1", { command: "echo example", wait: false, pause: true }).on()

class CommandPromptAction extends CustomHotkey.ActionBase {
  static defaultOptions := { command: "", wait: true, pause: false }
  isActionData(data) {
    return IsObject(data) && ObjHasKey(data, "command")
  }
  call() {
    data := this.data

    command := data.command
    if (data.pause) {
      command .= " & pause"
    }
    this.executeAction({ run: A_ComSpec
                       , args: [ "/c", command ]
                       , wait: data.wait })
  }
}
