//
//  YYVolumeManager.h
//  Lix
//
//  Created by Phoenix on 2017/9/5.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYVolumeDelegate <NSObject>
@optional
- (void)volumeChanged:(float)value;
@end

@interface YYVolumeManager : NSObject
@property (nonatomic, weak) id<YYVolumeDelegate> delegate;
@property (nonatomic, assign) float volume;
@property (nonatomic, assign) BOOL defaultVolumeUI;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (YYVolumeManager *)shared;
+ (void)releaseSingleton;
- (void)removeNotification;
@end
