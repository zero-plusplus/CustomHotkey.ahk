#SingleInstance, Force
#Include %A_LineFile%\..\..\..\..\..\src\CustomHotkey.ahk
CustomHotkey.debugMode := true

; カーソルの位置操作
new CustomHotkey("変換 & w", "{Blind}{Up}").on()
new CustomHotkey("変換 & s", "{Blind}{Down}").on()
new CustomHotkey("変換 & a", "{Blind}{Left}").on()
new CustomHotkey("変換 & d", "{Blind}{Right}").on()

; ウィンドウの位置操作
new CustomHotkey("無変換 & w", "#{Up}").on()
new CustomHotkey("無変換 & s", "#{Down}").on()
new CustomHotkey("無変換 & a", "#{Left}").on()
new CustomHotkey("無変換 & d", "#{Right}").on()

; マウスの位置操作
new CustomHotkey("変換 & 無変換", { keyRepeat: "1ms"
                                 , w: { y: -10, speed: 0 }
                                 , s: { y: 10, speed: 0 }
                                 , a: { x: -10, speed: 0 }
                                 , d: { x: 10, speed: 0 } }).on()

; マウスホイールによるスクロール操作
new CustomHotkey("無変換 & 変換", { w: "{Blind}{WheelUp}"
                                 , s: "{Blind}{WheelDown}"
                                 , a: "{Blind}{WheelLeft}"
                                 , d: "{Blind}{WheelRight}" }).on()
