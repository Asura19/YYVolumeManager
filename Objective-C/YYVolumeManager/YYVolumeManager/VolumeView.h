//
//  VolumeView.h
//  YYVolumeManager
//
//  Created by Phoenix on 2019/2/19.
//  Copyright © 2019 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VolumeView : UIView
@property (nonatomic, assign) CGFloat volume;
- (instancetype)initWithVolume:(CGFloat)volume;
@end

NS_ASSUME_NONNULL_END
