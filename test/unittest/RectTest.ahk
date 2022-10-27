#Include %A_LineFile%\..\..\..\src\CustomHotkey.ahk

util := CustomHotkey.Util

testData := []
testData.push(new util.Rect(0, 0, 30, 30))
testData.push(new util.Rect([ 0, 0 ], [ 30, 30 ]))
testData.push(new util.Rect([ { x: 0, y: 0 }, { x: 30, y: 30 } ]))
testData.push(new util.Rect({ x: 0, y: 0, w: 30, h: 30 }))
testData.push(new util.Rect([ [ 0, 0 ], [ 30, 30 ] ]))

for i, rect in testData {
  util.assert(rect.x == 0)
  util.assert(rect.y == 0)
  util.assert(rect.width == 30)
  util.assert(rect.height == 30)

  util.assert(rect.x == rect.x1)
  util.assert(rect.y == rect.y1)
  util.assert(rect.width == rect.w)
  util.assert(rect.height == rect.h)
}

testData := []
testData.push(new util.Rect(15, 15, 10, 10))
testData.push(new util.Rect([ 15, 15 ], [ 25, 25 ]))
testData.push(new util.Rect([ { x: 15, y: 15 }, { x: 25, y: 25 } ]))
testData.push(new util.Rect({ x: 15, y: 15, w: 10, h: 10 }))
testData.push(new util.Rect([ [ 15, 15 ], [ 25, 25 ] ]))

for i, rect in testData {
  util.assert(rect.x == 15)
  util.assert(rect.y == 15)
  util.assert(rect.width == 10)
  util.assert(rect.height == 10)
}

rect1 := new util.Rect(0, 0, 30, 30)
util.assert(rect1.contains(rect1))

rect2 := new util.Rect(5, 5, 15, 15)
util.assert(rect1.contains(rect2))

rect3 := new util.Rect(-15, -15, 10, 10)
util.assert(!rect1.contains(rect3))

rect4 := new util.Rect(35, 35, 10, 10)
util.assert(!rect1.contains(rect4))
ExitApp