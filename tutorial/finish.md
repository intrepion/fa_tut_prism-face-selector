# Finish

For web, start the Flutter app from the repository root with:

```bash
just run
```

or:

```bash
just run-web
```

Then open `http://localhost:25616` in your browser.

For iOS, open the simulator, list devices, and run with an actual simulator id or name:

```bash
open -a Simulator
just devices
just run-ios device="<ios-device-id-or-name>"
```

For Android, use:

```bash
just run-android device="<android-device-id-or-name>"
```

For macOS desktop, use:

```bash
just run-macos
```

For Windows or Linux, run the matching command on that host platform:

```bash
just run-windows
just run-linux
```

After the first successful iOS run, if CocoaPods added shared iOS project files like these:

- `workspace/ios/Runner.xcodeproj/project.pbxproj`
- `workspace/ios/Runner.xcworkspace/contents.xcworkspacedata`
- `workspace/ios/Podfile.lock`

then run:

```bash
git add --all
git commit --message "Add iOS CocoaPods workspace files"
```

After the first successful macOS run, if CocoaPods added shared macOS project files like these:

- `workspace/macos/Runner.xcodeproj/project.pbxproj`
- `workspace/macos/Runner.xcworkspace/contents.xcworkspacedata`
- `workspace/macos/Podfile.lock`

then run:

```bash
git add --all
git commit --message "Add macOS CocoaPods workspace files"
```

Try this flow:

- leave `front` selected and drag a rectangle on the selection canvas
- switch to `right` and drag a second rectangle
- confirm the summary updates with normalized values between `0.00` and `1.00`
- restart the app and notice that this first tutorial path keeps state only in memory
