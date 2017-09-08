//
//  VolumeSlider.m
//  Lix
//
//  Created by Phoenix on 2017/9/5.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "VolumeSlider.h"

@interface VolumeSlider ()
@property (nonatomic, strong) UIImageView *volumeIcon;
@property (nonatomic, strong) CALayer *sliderLayer;
@end

@implementation VolumeSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        
        self.volumeIcon = [UIImageView new];
        self.volumeIcon.image = [UIImage imageNamed:@"volume"];
        [self addSubview:self.volumeIcon];

        CALayer *backLayer = [CALayer new];
        backLayer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        backLayer.cornerRadius = 2;
        [self.layer addSublayer:backLayer];
        
        self.sliderLayer = [CALayer new];
        self.sliderLayer.backgroundColor = [UIColor whiteColor].CGColor;
        self.sliderLayer.cornerRadius = 2;
        [backLayer addSublayer:self.sliderLayer];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        CGFloat width = 300;
        CGFloat height = 18;
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - width) / 2, 17, width, height);
        
        self.volumeIcon.frame = CGRectMake(0, 0, height, height);
        backLayer.frame = CGRectMake(height + 10, (height - 4) / 2.0, width - height - 10, 4);
        self.sliderLayer.frame = backLayer.bounds;
        
        
    }
    return self;
}

- (void)initializeWithValue:(float)value {
    _value = value;
    [self setupSliderWithValue:value];
}

- (void)setValue:(float)value {
    _value = value;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideSelf)
                                               object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alpha = 1;
        [self setupSliderWithValue:value];
    });
    [self performSelector:@selector(hideSelf)
               withObject:nil
               afterDelay:2.0];
}

- (void)setupSliderWithValue:(float)value {
    CGRect temp = self.sliderLayer.frame;
    temp.size.width = (300 - 18 - 10) * value;
    self.sliderLayer.frame = temp;
    if (value == 0) {
        self.volumeIcon.image = [UIImage imageNamed:@"volume_silent"];
    }
    else {
        self.volumeIcon.image = [UIImage imageNamed:@"volume"];
    }
}

- (void)hideSelf {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alpha = 0;
    });
}

@end
