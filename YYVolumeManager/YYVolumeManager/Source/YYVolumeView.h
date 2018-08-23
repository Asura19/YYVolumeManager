//
//  YYVolumeView.h
//  YYVolumeManager
//
//  Created by Phoenix on 2018/8/23.
//  Copyright © 2018 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYVolumeView : UIView
@property (nonatomic, assign) CGFloat volume;
- (instancetype)initWithVolume:(CGFloat)volume;
@end

NS_ASSUME_NONNULL_END
