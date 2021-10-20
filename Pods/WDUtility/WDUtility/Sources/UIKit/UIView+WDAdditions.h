//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIViewAutoresizingFlexibleAllMargins (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)
#define UIViewAutoresizingFlexibleSize (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)


@interface UIView (WDTTCategory)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint originPoint;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)offsetFromView:(UIView*)otherView;

/**
 * The view controller whose view contains this view.
 */
- (UIViewController*)viewController;

+ (CGSize)getAppFrameSize;
+ (CGRect)getAppFrameBounds;
+ (CGRect)getAppFrame;
+ (BOOL)isInterfacePortrait;
+ (void)postAnOrientationChangedNotification;

+ (void)dismissGlobalKeyboard;

- (UIView*)subviewWithTag:(NSInteger)tag;

- (UIView*)findSubiewOfClassName:(NSString*)className;

// 主动发起旋转通知
//+ (void)rotationToInterfaceOrientation:(NSTimeInterval)duration;

@end


@interface UIFont (WDTTCategory)

/**
 * Gets the height of a line of text with this font.
 *
 * Why this isn't part of UIFont is beyond me. This is the height you would expect to get
 * by calling sizeWithFont.
 *
 * App Store-safe method declaration.
 * Hurrah for broken static code analysis.
 */
- (CGFloat)ttLineHeight;

@end


@interface UIView (WDAdditions)

///>根据tag值在子视图中查找
- (UIView*)subviewWithTag:(NSInteger)tag;

///>获取程序Rootview
+ (UIView*)getRootview;
@end

@interface CALayer (WDCleanUp)

- (void)cleanUpLayerContents;

@end

@interface UIView (WDCapture)

- (UIImage*)snapshotImageInRect:(CGRect)rect;

- (UIImage*)oldSnapshotImageInRect:(CGRect)rect;

@end

@interface UIView (WDAnimate)
- (void)rotate;
- (void)rotateWithDuration:(double)duration;
@end
