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

@interface ViewController ()<YYVolumeDelegate>
@property (nonatomic, assign) CGFloat originalVolume;
@property (nonatomic, assign) CGPoint touchStartPoint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 使音量控制实体键响应“音量”而不是”铃声”
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    [YYVolumeManager shared].delegate = self;
}

- (IBAction)setDefaultVolumeUI:(UISwitch *)sender {
    if ([sender isOn]) {
        [[YYVolumeManager shared] setDefaultVolumeUI:YES];
    }
    else {
        [[YYVolumeManager shared] setDefaultVolumeUI:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.touchStartPoint = [touch locationInView:self.view];
    self.originalVolume = [YYVolumeManager shared].volume;
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGFloat deltaY = point.y - self.touchStartPoint.y;
    [YYVolumeManager shared].volume = self.originalVolume - 3 * deltaY / self.view.frame.size.height;
}
@end
