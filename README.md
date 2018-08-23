# YYVolumeManager

As we all know, it is not convenient to change media volume in iOS. So I write this tool to make it easy.

# Useage
```
[[YYVolumeManager shared] addObserver:self];
```

Back to Default volume UI
```
[[YYVolumeManager shared] setDefaultVolumeUI:YES];
```

Do something if you want when wolume changed
```
- (void)volumeChanged:(CGFloat)value {}
```

You can use your custom UI if you do not like mine.
