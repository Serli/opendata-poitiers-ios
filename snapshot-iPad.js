#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();


target.delay(10)
//captureLocalizedScreenshot("0-LandingScreen")

target.frontMostApp().mainWindow().elements()[0].elements()["Site appui vélo - 3 places, 20 Rue Henri Pétonnet"].tap();
target.delay(1)
captureLocalizedScreenshot("1-Detail")

target.frontMostApp().mainWindow().elements()[0].popover().buttons()[0].tap();
target.delay(5)
captureLocalizedScreenshot("2-Path")


target.frontMostApp().mainWindow().buttons()["More Info"].tap();
target.delay(3)
captureLocalizedScreenshot("4-Info")
