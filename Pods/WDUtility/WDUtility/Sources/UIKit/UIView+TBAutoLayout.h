//
//  UIView+AutoLayout.h
//  AutoLayoutDemo
//
//  Created by shazhou on 14-10-13.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ALRelative) {
    ALRelativeToLeft,
    ALRelativeToRight,
    ALRelativeAbove,
    ALRelativeBelow
};

typedef NS_ENUM(NSInteger, ALEdge) {
    ALEdgeLeft,
    ALEdgeRight,
    ALEdgeTop,
    ALEdgeBottom,
    ALEdgeCenterXAxis,
    ALEdgeCenterYAxis
};

typedef NS_ENUM(NSInteger, ALDimension) {
    ALDimensionWidth = NSLayoutAttributeWidth,
    ALDimensionHeight = NSLayoutAttributeHeight
};

typedef NS_ENUM(NSInteger, ALConstraintsConflictOption) {
    /**
     *  默认，覆盖相同的constraint
     */
    ALConstraintsConflictOptionReplaced,
    
    /**
     * 系统提供warning
     */
    ALConstraintsConflictOptionSystemWarning
};

typedef struct TBAutoLayoutMargins {
    CGFloat top, left, bottom, right;
} TBAutoLayoutMargins;

UIKIT_STATIC_INLINE TBAutoLayoutMargins TBAutoLayoutMarginsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    TBAutoLayoutMargins margins = {top, left, bottom, right};
    return margins;
}

@interface UIView (TBAutoLayout)

- (NSLayoutConstraint*)getWidthConstraint;

- (NSLayoutConstraint*)getHeightConstraint;

/**
 *  如果已经设置frame，会自动把frame转换成constraints
 */
- (void)autoLayout;

- (void)autoLayoutWithOption:(ALConstraintsConflictOption)option;

- (void)autoLayoutWithPoint:(CGPoint)point;

- (void)autoLayoutWithPoint:(CGPoint)point option:(ALConstraintsConflictOption)option;

- (void)autoLayoutWithWidth:(CGFloat)width;

- (void)autoLayoutWithWidth:(CGFloat)width option:(ALConstraintsConflictOption)option;

- (void)autoLayoutWithHeight:(CGFloat)height;

- (void)autoLayoutWithHeight:(CGFloat)height option:(ALConstraintsConflictOption)option;

- (void)autoLayoutWithSize:(CGSize)size;

- (void)autoLayoutWithSize:(CGSize)size option:(ALConstraintsConflictOption)option;

- (void)autoLayoutWithFrame:(CGRect)frame;

- (void)autoLayoutWithFrame:(CGRect)frame option:(ALConstraintsConflictOption)option;

// peer view
- (void)autoLayoutAlignWithView:(UIView*)anchorView withEdge:(ALEdge)edge;

- (void)autoLayoutAlignWithView:(UIView*)anchorView withEdge:(ALEdge)edge option:(ALConstraintsConflictOption)option;

- (void)autoLayout:(ALRelative)relativeType ofView:(UIView*)anchorView offset:(CGFloat)offset;

- (void)autoLayout:(ALRelative)relativeType ofView:(UIView *)anchorView offset:(CGFloat)offset option:(ALConstraintsConflictOption)option;

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView *)peerView;

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView *)peerView option:(ALConstraintsConflictOption)option;

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView *)peerView offset:(CGFloat)offset;

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView*)peerView offset:(CGFloat)offset option:(ALConstraintsConflictOption)option;

//parent view
- (void)autoLayoutWithLayoutMargin:(ALEdge)edge margin:(CGFloat)margin;

- (void)autoLayoutWithLayoutMargin:(ALEdge)edge margin:(CGFloat)margin option:(ALConstraintsConflictOption)option;

- (void)autoLayoutWithLayoutMargins:(TBAutoLayoutMargins)margins;

- (void)autoLayoutWithLayoutMargins:(TBAutoLayoutMargins)margins option:(ALConstraintsConflictOption)option;

- (void)autoLayoutCenterInParent;

- (void)autoLayoutCenterInParentWithOption:(ALConstraintsConflictOption)option;

- (void)autoLayoutCenterHorizontallyInParent;

- (void)autoLayoutCenterHorizontallyInParentWithOption:(ALConstraintsConflictOption)option;

- (void)autoLayoutCenterVerticallyInParent;

- (void)autoLayoutCenterVerticallyInParentWithOption:(ALConstraintsConflictOption)option;

@end
