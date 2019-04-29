import Cocoa

var nonsenseID: CGDirectDisplayID = 0
var nonsenseCount: UInt32 = 0

//display count
var count: UInt32 = 0

//create an "UnsafeMutablePointer<CGDirectDisplayID>" object "id" and initialize it
//reference: https://developer.apple.com/documentation/swift/unsafemutablepointer#2846178
var temp: [UInt32] = [0,0,0,0,0,0,0,0,0,0]
let IDList = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: 10)
IDList.initialize(from: &temp, count: 10)

//get displays info.
//the number of monitors ("count" variable) is actually
//equal to the number of nonvanishing elements in "id" variable.
//reference: https://developer.apple.com/documentation/coregraphics/quartz_display_services#1655882
CGGetActiveDisplayList(10, IDList, &count)

// get current coordinate of the cursor (the origin is the bottom left corner of the main display).
// reference: https://developer.apple.com/documentation/appkit/nsevent#1651475
var currentPoint = NSEvent.mouseLocation
// transform into the coordinate system with origin at the top left corner.
var mainHeight = CGDisplayPixelsHigh(CGMainDisplayID())
currentPoint = CGPoint(x: currentPoint.x, y: CGFloat(mainHeight)-currentPoint.y)

if Int(count) > 1 {
    // get the display ID under cursor and find the next ID
    var currentID: CGDirectDisplayID = 0
    CGGetDisplaysWithPoint(currentPoint, 1, &currentID, &nonsenseCount)
    if currentID == 0 {// when failed to get an ID
        currentID = CGMainDisplayID()
    }
    var nextID: CGDirectDisplayID = 0
    for i in stride(from: 0, to: count, by: 1) {
        if IDList[Int(i)] == currentID {
            nextID = IDList[(Int(i)+1)%Int(count)]
        }
    }
    //print(IDList[0], IDList[1], IDList[2], IDList[3], IDList[4])
    //print(currentID)
    //print(nextID)

    // move mouse to the center of the next screen
    // reference: https://developer.apple.com/documentation/coregraphics/quartz_display_services#1656342
    // reference: https://developer.apple.com/documentation/coregraphics/1455258-cgdisplaymovecursortopoint
    let height = CGDisplayPixelsHigh(nextID)
    let width = CGDisplayPixelsWide(nextID)
    CGDisplayMoveCursorToPoint(nextID, CGPoint(x: width/2, y: height/2))
} else {
    // right mouse button down (if add right button up event, the popup panel will dispear at once)
    // reference: https://stackoverflow.com/questions/41908620/how-to-simulate-mouse-click-from-mac-app-to-other-application#answer-50463457
    // reference: https://developer.apple.com/documentation/coregraphics/cgevent
    let source = CGEventSource(stateID: .hidSystemState)
    let rightDown = CGEvent(mouseEventSource: source, mouseType: .rightMouseDown, mouseCursorPosition: currentPoint, mouseButton: .right)
    rightDown?.post(tap: .cghidEventTap)
}