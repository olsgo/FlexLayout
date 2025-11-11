/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <yoga/Yoga.h>
#import "YGLayout.h"

#if TARGET_OS_IPHONE || TARGET_OS_TV
@class UIView;
#elif TARGET_OS_OSX
@class NSView;
#endif

@interface YGLayout ()

@property(nonatomic, assign, readonly) YGNodeRef node;

#if TARGET_OS_IPHONE || TARGET_OS_TV
- (instancetype)initWithView:(UIView*)view;
#elif TARGET_OS_OSX
- (instancetype)initWithView:(NSView*)view;
#endif

@end
