# YYVolumeManager

As we all know, it is not convenient to change media volume in iOS. So I write this tool to make it easy.

# Useage
```
// maybe I will change it to multiple delegate someday
[YYVolumeManager shared].delegate = self;
```

Back to Default volume UI
```
[[YYVolumeManager shared] setDefaultVolumeUI:YES];
```

Do something if you want when wolume changed
```
- (void)volumeChanged:(float)value {}
```

You can use your custom UI if you do not like mine.
