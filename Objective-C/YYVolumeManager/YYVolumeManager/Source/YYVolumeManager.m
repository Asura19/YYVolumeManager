//
//  YYVolumeManager.m
//  Lix
//
//  Created by Phoenix on 2017/9/5.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "YYVolumeManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface YYVolumeManager()
@property (nonatomic, strong) MPVolumeView *defaultVolumeView;
@property (nonatomic, strong) UISlider *volumeSlider;
@end

@implementation YYVolumeManager {
    NSHashTable *_observers;
}

static YYVolumeManager *_instance;
static dispatch_once_t onceToken;

+ (YYVolumeManager *)shared {
    dispatch_once(&onceToken, ^{
        _instance = [[super alloc] _init];
    });
    return _instance;
}

+ (void)releaseSingleton {
    [_instance removeNotification];
    onceToken = 0;
    _instance = nil;
}

- (void)dealloc {
#if DEBUG
    NSLog(@"YYVolumeManager dealloc");
#endif
}

- (instancetype)_init {
    self = [super init];
    _observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPersonality capacity:0];
    _volume = [[AVAudioSession sharedInstance] outputVolume];
    if ([NSThread isMainThread]) {
        self.defaultVolumeView = [[MPVolumeView alloc] init];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.defaultVolumeView = [[MPVolumeView alloc] init];
        });
    }
    [self registeNotification];
    return self;
}

- (void)addObserver:(id<YYVolumeObserver>)observer {
    if (!observer) {
        return;
    }
    [_observers addObject:observer];
}

- (void)removeObserver:(id<YYVolumeObserver>)observer {
    if (!observer) {
        return;
    }
    [_observers removeObject:observer];
}

- (void)setCustomVolumeUI:(BOOL)customVolumeUI {
    [self.defaultVolumeView removeFromSuperview];
    if (customVolumeUI) {
        [self.defaultVolumeView setFrame:CGRectMake(-100, -100, 40, 40)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.defaultVolumeView];
    }
}


- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        for (UIView *view in self.defaultVolumeView.subviews) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeSlider;
}

- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    [self.volumeSlider setValue:volume
                       animated:NO];
}

- (void)registeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)volumeChanged:(NSNotification *)notification {
    CGFloat currentVolume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    self.volume = currentVolume;

    for (id<YYVolumeObserver> observer in _observers.copy) {
        if (observer && [observer respondsToSelector:@selector(volumeChanged:)]) {
            [observer volumeChanged:currentVolume];
        }
    }
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
@end
