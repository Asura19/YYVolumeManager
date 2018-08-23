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
        _volume = volume;
    }
    return self;
}
@end
