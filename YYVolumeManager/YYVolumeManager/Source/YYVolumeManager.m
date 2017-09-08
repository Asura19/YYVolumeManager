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
#import "VolumeSlider.h"

@interface YYVolumeManager()
@property (nonatomic, strong) MPVolumeView *volumeView;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) VolumeSlider *customVolumeSlider;
@end

@implementation YYVolumeManager
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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.volumeView = [[MPVolumeView alloc] init];
        [self.volumeView setFrame:CGRectMake(-100, -100, 40, 40)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
        _volume = [[AVAudioSession sharedInstance] outputVolume];
        _customVolumeSlider = [VolumeSlider new];
        [_customVolumeSlider initializeWithValue:_volume];
    });
    [self registeNotification];
    return self;
}

- (void)setDefaultVolumeUI:(BOOL)defaultVolumeUI {
    [self.volumeView removeFromSuperview];
    self.customVolumeSlider.hidden = defaultVolumeUI;
    if (defaultVolumeUI) {
        
    }
    else {
        [self.volumeView setFrame:CGRectMake(-100, -100, 40, 40)];
        [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
    }
}

- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        for (UIView *view in self.volumeView.subviews) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeSlider;
}

- (void)setVolume:(float)volume {
    _volume = volume;
    [self.volumeSlider setValue:volume
                       animated:NO];
}

- (void)registeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)volumeChanged:(NSNotification *)notification {
    float currentVolume = [[[notification userInfo]
                            objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
                           floatValue];
    self.volume = currentVolume;
    _customVolumeSlider.value = currentVolume;
    if (self.delegate && [self.delegate respondsToSelector:@selector(volumeChanged:)]) {
        [self.delegate volumeChanged:currentVolume];
    }
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                  object:nil];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
@end
