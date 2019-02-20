//
//  VolumeView.m
//  YYVolumeManager
//
//  Created by Phoenix on 2019/2/19.
//  Copyright © 2019 Phoenix. All rights reserved.
//

#import "VolumeView.h"

static CGFloat const SLIDER_CORNERRADIUS = 2;
static CGFloat const SLIDER_WIDTH = 300;
static CGFloat const SLIDER_HEIGHT = 18;

@interface VolumeView ()
@property (nonatomic, strong) UIImageView *volumeIcon;
@property (nonatomic, strong) CALayer *sliderLayer;
@property (nonatomic, strong) CALayer *backLayer;
@end

@implementation VolumeView

- (instancetype)initWithVolume:(CGFloat)volume {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.alpha = 0;
        _volume = volume;
        
        
        self.volumeIcon = [UIImageView new];
        self.volumeIcon.image = [UIImage imageNamed:@"volume"];
        [self addSubview:self.volumeIcon];
        
        CALayer *backLayer = [CALayer new];
        self.backLayer = backLayer;
        backLayer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        backLayer.cornerRadius = SLIDER_CORNERRADIUS;
        [self.layer addSublayer:backLayer];
        
        self.sliderLayer = [CALayer new];
        self.sliderLayer.backgroundColor = [UIColor whiteColor].CGColor;
        self.sliderLayer.cornerRadius = SLIDER_CORNERRADIUS;
        [backLayer addSublayer:self.sliderLayer];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChange)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}


- (void)layoutSubviews {
    CGFloat width = SLIDER_WIDTH;
    CGFloat height = SLIDER_HEIGHT;
    self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - width) / 2, 88, width, height);
    
    self.volumeIcon.frame = CGRectMake(0, 0, height, height);
    self.backLayer.frame = CGRectMake(height + 10, (height - 4) / 2.0, width - height - 10, 4);
    self.sliderLayer.frame = self.backLayer.bounds;
    [self setupSliderWithValue:self.volume];
}

- (void)setupSliderWithValue:(float)value {
    [self excuteSyncMainThreadBlock:^{
        CGRect temp = self.sliderLayer.frame;
        temp.size.width = (SLIDER_WIDTH - SLIDER_HEIGHT - 10) * value;
        self.sliderLayer.frame = temp;
        if (value == 0) {
            self.volumeIcon.image = [UIImage imageNamed:@"volume_silent"];
        }
        else {
            self.volumeIcon.image = [UIImage imageNamed:@"volume"];
        }
    }];
}
- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange {
    [self setNeedsLayout];
}


- (void)setVolume:(CGFloat)volume {
    [self setupSliderWithValue:volume];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideSelf)
                                               object:nil];
    [self excuteSyncMainThreadBlock:^{
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
        self.alpha = 1;
    }];
    
    
    [self performSelector:@selector(hideSelf)
               withObject:nil
               afterDelay:2.0];
}

- (void)hideSelf {
    [self excuteSyncMainThreadBlock:^{
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        }];
    }];
}

- (void)excuteSyncMainThreadBlock:(dispatch_block_t)block {
    if (!block) return;
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@end
