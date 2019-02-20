# YYVolumeManager

As we all know, it is not convenient to change media volume in iOS. So I write this tool to make it easy. And provide swift version.

# Usage

* Change volume directly.
```
[YYVolumeManager shared].volume = 0.5;
```

* Add observer.
```
[[YYVolumeManager shared] addObserver:self];
```

* Use custom volume UI
```
[[YYVolumeManager shared] setCustomVolumeUI:YES];
```

* Do something if you want when volume changed, such as update custom volume UI.
```
- (void)volumeChanged:(CGFloat)value {}
```

* You can use your custom UI if you do not like mine.
* Debug on real iOS device.
