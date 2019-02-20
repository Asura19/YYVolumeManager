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
//#import "YYVolumeView.h"
#import "VolumeView.h"

@interface ViewController () <YYVolumeObserver>
@property (nonatomic, assign) CGFloat originalVolume;
@property (nonatomic, assign) CGPoint touchStartPoint;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISwitch *volumeTypeSwitch;

@property (nonatomic, strong) VolumeView *customVolumeView;
@end

@implementation ViewController

- (VolumeView *)customVolumeView {
    if (!_customVolumeView) {
        CGFloat volume = [YYVolumeManager shared].volume;
        _customVolumeView = [[VolumeView alloc] initWithVolume:volume];
        _customVolumeView.hidden = !self.volumeTypeSwitch.isOn;
    }
    return _customVolumeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使音量控制实体键响应“音量”而不是”铃声”
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    [[YYVolumeManager shared] addObserver:self];
    CGFloat volume = [YYVolumeManager shared].volume;
    self.slider.value = volume;
}

- (void)dealloc {
    [[YYVolumeManager shared] removeObserver:self];
}

- (IBAction)changeVolume:(UISlider *)sender {
    [YYVolumeManager shared].volume = sender.value;
}

- (IBAction)setCustomVolumeUI:(UISwitch *)sender {
    self.customVolumeView.hidden = !sender.isOn;
    [[YYVolumeManager shared] setCustomVolumeUI:sender.isOn];
}

- (void)volumeChanged:(CGFloat)value {
    NSLog(@"Media volume is %@", @(value));
    self.slider.value = value;
    self.customVolumeView.volume = value;
}
@end
