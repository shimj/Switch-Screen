import Cocoa

let source = CGEventSource(stateID: .hidSystemState)
var position = NSEvent.mouseLocation
var mainHeight = CGDisplayPixelsHigh(CGMainDisplayID())
position = CGPoint(x: position.x, y: CGFloat(mainHeight)-position.y)
let leftDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: position , mouseButton: .left)
leftDown?.post(tap: .cghidEventTap)