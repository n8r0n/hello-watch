# hello-watch

This sample project demonstrates a problem transferring images between an iOS app and an Apple Watch app. It appears that this may be a bug in the simulators.

## Requirements

This project uses the App Group group.com.mycompany.HelloWatch to share data between iOS and Watch apps.

## Steps

 1. Build and Run project using Xcode 7.2, iOS 9.2, WatchOS 2.1
 2. After running the project, inspect the console logs for both phone and watch apps, using OS X Console, Xcode debugger, or other mechanism.
 3. If filtering OS X Console logs, can search for console output containing the string "Hello"
 4. When the watch app opens, it should request that the iOS app update its WAN IP address label, and also fetch a webcam image from the internet for display.
 5. The webcam image can be refreshed by closing and reopening the watch app, or by pressing the **Push Image** button on the iOS app.
 6. When fetching the image using either method (watch pull or phone push), the image transfer will fail roughly half the time.
 7. When the image transfer succeeds, the watch app should display the new webcam image. Also, the log will show "Rx'd XXXXX bytes of image data" for the received image.
 8. During failed transfers, no message about "Rx'd XXXXXX bytes" will appear, and various other system logging will be generated in both the watch and phone simulator console logs.
