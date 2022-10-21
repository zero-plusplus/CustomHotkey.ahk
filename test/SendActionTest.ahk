#Include %A_LineFile%\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

new CustomHotkey("RCtrl & 1", "{a}{b}{c}").on()
new CustomHotkey("RCtrl & 2", "{Input}{a}").on()
new CustomHotkey("RCtrl & 3", "{Input}{Raw}{a}").on()
new CustomHotkey("RCtrl & 4", "{Input}{Blind}{a}").on()
new CustomHotkey("RCtrl & 5", "^{a}").on()
new CustomHotkey("RCtrl & 6", { send: "abc", mode: "Input" }).on()
new CustomHotkey("RCtrl & 7", "{Input|L3}{d 2}ab{a}").on()
new CustomHotkey("RCtrl & 8", "{Input}{Raw}1`n2").on()
new CustomHotkey("RCtrl & 9", "{Input|M}{Raw}1`n2").on()
new CustomHotkey("RCtrl & 0", "{Input}{Enter}").on()

new CustomHotkey("RCtrl & q", "{Event|I1}{a}{b}{c}").on()
new CustomHotkey("RCtrl & w", "{Event|I1s}{a}{b}{c}").on()
new CustomHotkey("RCtrl & e", "{Event|I1000}{a}{b}{c}").on()

new CustomHotkey("RCtrl & a", "{Event|I0}{a}{b}{c}").on()
new CustomHotkey("RCtrl & s", "{Event|I-1s}{a}{b}{c}").on()
new CustomHotkey("RCtrl & d", "{Event|I-1000}{a}{b}{c}").on()

new CustomHotkey("RCtrl & z", new CustomHotkey.SendAction("{a}{b}{c}")).on()
new CustomHotkey("RCtrl & x", "^{SuffixKey}").on()
new CustomHotkey("RCtrl & c", "{Event|D100 P100}{Text}abcdefghijk").on()
new CustomHotkey("RCtrl & v", "{Input}{Text}({SelectedText})").on()
new CustomHotkey("RCtrl & b", "{Input}{Text}{Clipboard}").on()
new CustomHotkey("RCtrl & Esc", "{Input}{Text}{Clipboard}").on()
