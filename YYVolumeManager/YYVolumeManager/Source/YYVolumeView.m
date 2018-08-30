//
//  YYVolumeView.m
//  YYVolumeManager
//
//  Created by Phoenix on 2018/8/23.
//  Copyright © 2018 Phoenix. All rights reserved.
//

#import "YYVolumeView.h"

@implementation YYVolumeView

- (instancetype)initWithVolume:(CGFloat)volume {
    self = [super init];
    if (self) {
        self.alpha = 0;
        _volume = volume;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChange)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange {
    [self setNeedsLayout];
}


- (void)setVolume:(CGFloat)volume {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideSelf)
                                               object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
        self.alpha = 1;
    });
    
    [self performSelector:@selector(hideSelf)
               withObject:nil
               afterDelay:2.0];
}

- (void)hideSelf {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        }];
    });
}

@end
