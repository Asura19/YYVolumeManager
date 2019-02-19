//
//  YYVolumeManager.h
//  Lix
//
//  Created by Phoenix on 2017/9/5.
//  Copyright © 2017年 Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YYVolumeObserver <NSObject>
@optional
- (void)volumeChanged:(CGFloat)value;
@end

@interface YYVolumeManager : NSObject
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) BOOL customVolumeUI;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (nullable instancetype)shared;
+ (void)releaseSingleton;

- (void)addObserver:(id<YYVolumeObserver>)observer;
- (void)removeObserver:(id<YYVolumeObserver>)observer;
@end

NS_ASSUME_NONNULL_END
