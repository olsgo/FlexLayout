/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if TARGET_OS_IPHONE || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_OSX
#import <AppKit/AppKit.h>
#endif

#import "YGLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^YGLayoutConfigurationBlock)(YGLayout* layout);

#if TARGET_OS_IPHONE || TARGET_OS_TV
@interface UIView (Yoga)

/**
 The YGLayout that is attached to this view. It is lazily created.
 */
@property(nonatomic, readonly, strong) YGLayout* yoga;
/**
 Indicates whether or not Yoga is enabled
 */
@property(nonatomic, readonly, assign) BOOL isYogaEnabled;

/**
 In ObjC land, every time you access `view.yoga.*` you are adding another
 `objc_msgSend` to your code. If you plan on making multiple changes to
 YGLayout, it's more performant to use this method, which uses a single
 objc_msgSend call.
 */
- (void)configureLayoutWithBlock:(YGLayoutConfigurationBlock)block
    NS_SWIFT_NAME(configureLayout(block:));

@end
#elif TARGET_OS_OSX
@interface NSView (Yoga)

/**
 The YGLayout that is attached to this view. It is lazily created.
 */
@property(nonatomic, readonly, strong) YGLayout* yoga;
/**
 Indicates whether or not Yoga is enabled
 */
@property(nonatomic, readonly, assign) BOOL isYogaEnabled;

/**
 In ObjC land, every time you access `view.yoga.*` you are adding another
 `objc_msgSend` to your code. If you plan on making multiple changes to
 YGLayout, it's more performant to use this method, which uses a single
 objc_msgSend call.
 */
- (void)configureLayoutWithBlock:(YGLayoutConfigurationBlock)block
    NS_SWIFT_NAME(configureLayout(block:));

@end
#endif

NS_ASSUME_NONNULL_END
