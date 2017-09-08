//
//  VolumeSlider.h
//  Lix
//
//  Created by Phoenix on 2017/9/5.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeSlider : UIView
@property (nonatomic, assign) float value;
- (void)initializeWithValue:(float)value;
@end
