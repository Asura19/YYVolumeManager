//
//  ViewController.m
//  YYVolumeManager
//
//  Created by Phoenix on 2017/9/8.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import "ViewController.h"
#import "YYVolumeManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <YYVolumeObserver>
@property (nonatomic, assign) CGFloat originalVolume;
@property (nonatomic, assign) CGPoint touchStartPoint;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使音量控制实体键响应“音量”而不是”铃声”
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    [[YYVolumeManager shared] addObserver:self];
    self.slider.value = [YYVolumeManager shared].volume;
}

- (void)dealloc {
    [[YYVolumeManager shared] removeObserver:self];
}

- (IBAction)changeVolume:(UISlider *)sender {
    [YYVolumeManager shared].volume = sender.value;
}

- (IBAction)setDefaultVolumeUI:(UISwitch *)sender {
    if ([sender isOn]) {
        [[YYVolumeManager shared] setDefaultVolumeUI:YES];
    }
    else {
        [[YYVolumeManager shared] setDefaultVolumeUI:NO];
    }
}

- (void)volumeChanged:(CGFloat)value {
    NSLog(@"Media volume is %@", @(value));
    self.slider.value = value;
}
@end
