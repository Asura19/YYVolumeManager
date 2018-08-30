//
//  VolumeSlider.m
//  Lix
//
//  Created by Phoenix on 2017/9/5.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "VolumeSlider.h"

static CGFloat const SLIDER_CORNERRADIUS = 2;
static CGFloat const SLIDER_WIDTH = 300;
static CGFloat const SLIDER_HEIGHT = 18;


@interface VolumeSlider ()
@property (nonatomic, strong) UIImageView *volumeIcon;
@property (nonatomic, strong) CALayer *sliderLayer;
@property (nonatomic, strong) CALayer *backLayer;
@end

@implementation VolumeSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
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

- (void)setVolume:(CGFloat)volume {
    [self setupSliderWithValue:volume];
    [super setVolume:volume];
}

- (void)setupSliderWithValue:(float)value {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect temp = self.sliderLayer.frame;
        temp.size.width = (SLIDER_WIDTH - SLIDER_HEIGHT - 10) * value;
        self.sliderLayer.frame = temp;
        if (value == 0) {
            self.volumeIcon.image = [UIImage imageNamed:@"volume_silent"];
        }
        else {
            self.volumeIcon.image = [UIImage imageNamed:@"volume"];
        }
    });
}

@end
