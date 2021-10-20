//
//  UIView+AutoLayout.m
//  AutoLayoutDemo
//
//  Created by shazhou on 14-10-13.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "UIView+TBAutoLayout.h"

@implementation UIView (TBAutoLayout)

- (void)autoLayout
{
    [self autoLayoutWithOption:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithOption:(ALConstraintsConflictOption)option
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self autoLayoutWithFrame:self.frame option:option];
    }
}

- (NSLayoutConstraint*)getWidthConstraint
{
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        for (NSLayoutConstraint* constraint in self.constraints) {
            if ((constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth && constraint.secondItem == nil) || (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeWidth && constraint.firstItem == nil)) {
                return constraint;
            }
        }
    }
    return nil;
}

- (NSLayoutConstraint*)getHeightConstraint
{
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        for (NSLayoutConstraint* constraint in self.constraints) {
            if ((constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight && constraint.secondItem == nil) || (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeHeight && constraint.firstItem == nil)) {
                return constraint;
            }
        }
    }
    return nil;
}

#pragma mark - self size & pos

- (void)autoLayoutWithFrame:(CGRect)frame
{
    [self autoLayoutWithFrame:frame option:ALConstraintsConflictOptionReplaced];
    
}

- (void)autoLayoutWithFrame:(CGRect)frame option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self autoLayoutWithSize:frame.size option:option];
    
    [self autoLayoutWithPoint:frame.origin option:option];
}

- (void)autoLayoutWithSize:(CGSize)size
{
    [self autoLayoutWithSize:size option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithSize:(CGSize)size option:(ALConstraintsConflictOption)option
{
    [self autoLayoutWithWidth:size.width option:option];
    
    [self autoLayoutWithHeight:size.height option:option];
}

- (void)autoLayoutWithWidth:(CGFloat)width
{
    [self autoLayoutWithWidth:width option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithWidth:(CGFloat)width option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self addConstraint:widthConstraint option:option];
}

- (void)autoLayoutWithHeight:(CGFloat)height
{
    [self autoLayoutWithHeight:height option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithHeight:(CGFloat)height option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    [self addConstraint:heightConstraint option:option];
}

- (void)autoLayoutWithPoint:(CGPoint)point
{
    [self autoLayoutWithPoint:point option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithPoint:(CGPoint)point option:(ALConstraintsConflictOption)option
{
    [self autoLayoutWithXAxis:point.x option:option];
    
    [self autoLayoutWithYAxis:point.y option:option];
}

- (void)autoLayoutWithXAxis:(CGFloat)x
{
    [self autoLayoutWithXAxis:x option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithXAxis:(CGFloat)x option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* xConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:x];
    [self.superview addConstraint:xConstraint option:option];
}

- (void)autoLayoutWithYAxis:(CGFloat)y
{
    [self autoLayoutWithYAxis:y option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithYAxis:(CGFloat)y option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* yConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:y];
    [self.superview addConstraint:yConstraint option:option];
}

#pragma mark - relationship of peer view
- (void)autoLayout:(ALRelative)relativeType ofView:(UIView *)anchorView offset:(CGFloat)offset
{
    [self autoLayout:relativeType ofView:anchorView offset:offset option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayout:(ALRelative)relativeType ofView:(UIView *)anchorView offset:(CGFloat)offset option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    NSAssert(anchorView.superview, @"View's superview must not be nil. View:%@", anchorView);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* constraint;
    if (relativeType == ALRelativeToRight) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:anchorView attribute:NSLayoutAttributeRight multiplier:1.0 constant:offset];
    } else if (relativeType == ALRelativeToLeft) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:anchorView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-offset];
    } else if (relativeType == ALRelativeAbove) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:anchorView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-offset];
    } else if (relativeType == ALRelativeBelow) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:anchorView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:offset];
    }
    
    UIView* commonSuperView = [self getCommonSuperViewWithView:anchorView];
    NSAssert(commonSuperView, @"Common superview must not be nil. ");
    
    [commonSuperView addConstraint:constraint option:option];
}

- (void)autoLayoutAlignWithView:(UIView*)anchorView withEdge:(ALEdge)edge
{
    [self autoLayoutAlignWithView:anchorView withEdge:edge option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutAlignWithView:(UIView*)anchorView withEdge:(ALEdge)edge option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    NSAssert(anchorView.superview, @"View's superview must not be nil. View:%@", anchorView);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutAttribute attribute = NSLayoutAttributeNotAnAttribute;
    switch (edge) {
        case ALEdgeLeft:
            attribute = NSLayoutAttributeLeft;
            break;
        case ALEdgeRight:
            attribute = NSLayoutAttributeRight;
            break;
        case ALEdgeTop:
            attribute = NSLayoutAttributeTop;
            break;
        case ALEdgeBottom:
            attribute = NSLayoutAttributeBottom;
            break;
        case ALEdgeCenterXAxis:
            attribute = NSLayoutAttributeCenterY;
            break;
        case ALEdgeCenterYAxis:
            attribute = NSLayoutAttributeCenterX;
            break;
        default:
            break;
    }
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:anchorView attribute:attribute multiplier:1.0 constant:0];
    
    UIView* commonSuperView = [self getCommonSuperViewWithView:anchorView];
    NSAssert(commonSuperView, @"Common superview must not be nil. ");
    
    [commonSuperView addConstraint:constraint option:option];
}

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView *)peerView
{
    [self autoLayoutMatchDimension:dimension toDimension:toDimension ofView:peerView offset:0 option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView *)peerView option:(ALConstraintsConflictOption)option
{
    [self autoLayoutMatchDimension:dimension toDimension:toDimension ofView:peerView offset:0 option:option];
}

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView *)peerView offset:(CGFloat)offset
{
    [self autoLayoutMatchDimension:dimension toDimension:toDimension ofView:peerView offset:offset option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutMatchDimension:(ALDimension)dimension toDimension:(ALDimension)toDimension ofView:(UIView *)peerView offset:(CGFloat)offset option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutAttribute attribute = NSLayoutAttributeNotAnAttribute;
    switch (dimension) {
        case ALDimensionWidth:
            attribute = NSLayoutAttributeWidth;
            break;
        case ALDimensionHeight:
            attribute = NSLayoutAttributeHeight;
            break;
        default:
            break;
    }
    
    NSLayoutAttribute toAttribute = NSLayoutAttributeNotAnAttribute;
    switch (toDimension) {
        case ALDimensionWidth:
            toAttribute = NSLayoutAttributeWidth;
            break;
        case ALDimensionHeight:
            toAttribute = NSLayoutAttributeHeight;
            break;
        default:
            break;
    }
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:peerView attribute:toAttribute multiplier:1.0 constant:offset];
    #pragma clang diagnostic ignored "-Wunused-variable"
    UIView* commonSuperView = [self getCommonSuperViewWithView:peerView];
    NSAssert(commonSuperView, @"Common superview must not be nil. ");
    
    [self addConstraint:constraint option:option];
}

#pragma mark - relationship of parent view
- (void)autoLayoutWithLayoutMargins:(TBAutoLayoutMargins)margins
{
    [self autoLayoutWithLayoutMargins:margins option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithLayoutMargins:(TBAutoLayoutMargins)margins option:(ALConstraintsConflictOption)option
{
    [self autoLayoutWithLayoutMargin:ALEdgeLeft margin:margins.left option:option];
    
    [self autoLayoutWithLayoutMargin:ALEdgeTop margin:margins.top option:option];
    
    [self autoLayoutWithLayoutMargin:ALEdgeRight margin:margins.right option:option];
    
    [self autoLayoutWithLayoutMargin:ALEdgeBottom margin:margins.bottom option:option];
}

- (void)autoLayoutWithLayoutMargin:(ALEdge)edge margin:(CGFloat)margin
{
    [self autoLayoutWithLayoutMargin:edge margin:margin option:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutWithLayoutMargin:(ALEdge)edge margin:(CGFloat)margin option:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutAttribute attribute = NSLayoutAttributeNotAnAttribute;
    switch (edge) {
        case ALEdgeLeft:
            attribute = NSLayoutAttributeLeft;
            break;
        case ALEdgeTop:
            attribute = NSLayoutAttributeTop;
            break;
        case ALEdgeRight:
            attribute = NSLayoutAttributeRight;
            margin = -margin;
            break;
        case ALEdgeBottom:
            attribute = NSLayoutAttributeBottom;
            margin = -margin;
            break;
        default:
            break;
    }
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attribute multiplier:1.0 constant:margin];
    [self.superview addConstraint:constraint option:option];
}

- (void)autoLayoutCenterInParent
{
    [self autoLayoutCenterInParentWithOption:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutCenterInParentWithOption:(ALConstraintsConflictOption)option
{
    [self autoLayoutCenterHorizontallyInParentWithOption:option];
    
    [self autoLayoutCenterVerticallyInParentWithOption:option];
}

- (void)autoLayoutCenterHorizontallyInParent
{
    [self autoLayoutCenterHorizontallyInParentWithOption:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutCenterHorizontallyInParentWithOption:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.superview addConstraint:constraint option:option];
}

- (void)autoLayoutCenterVerticallyInParent
{
    [self autoLayoutCenterVerticallyInParentWithOption:ALConstraintsConflictOptionReplaced];
}

- (void)autoLayoutCenterVerticallyInParentWithOption:(ALConstraintsConflictOption)option
{
    NSAssert(self.superview, @"View's superview must not be nil. View:%@", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.superview addConstraint:constraint option:option];
}

#pragma mark - Internal func.
- (UIView*)getCommonSuperViewWithView:(UIView*)peerView
{
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([peerView isDescendantOfView:startView]) {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
    NSAssert(commonSuperview, @"Can't constrain two views that do not share a common superview. Make sure that both views have been added into the same view hierarchy.");
    return commonSuperview;
}

- (void)removeConstraintOfAttribute:(NSLayoutAttribute)attribute from:(UIView*)view
{
    for (NSLayoutConstraint* con in view.constraints) {
        if ((con.firstItem == self && con.firstAttribute == attribute) || (con.secondItem == self && con.secondAttribute == attribute)) {
            [view removeConstraint:con];
        }
    }
}

- (void)removeConstraintsOfAttribute:(NSLayoutAttribute)attribute ofView:(UIView*)view
{
    for (NSLayoutConstraint* con in self.constraints) {
        if ((con.firstItem == view && con.firstAttribute == attribute) || (con.secondItem == view && con.secondAttribute == attribute)) {
            [self removeConstraint:con];
        }
    }
}

- (void)addConstraint:(NSLayoutConstraint *)constraint option:(ALConstraintsConflictOption)option
{
    if (option == ALConstraintsConflictOptionReplaced) {
        [self addConstraintWithConflictInspect:constraint];
    } else {
        [self addConstraint:constraint];
    }
}

- (void)addConstraintWithConflictInspect:(NSLayoutConstraint *)constraint
{
    if (constraint.firstItem && constraint.secondItem) {
        if (constraint.firstItem == self) {
            [self removeConstraintsOfAttribute:constraint.secondAttribute ofView:constraint.secondItem];
        } else if (constraint.secondItem == self) {
            [self removeConstraintsOfAttribute:constraint.firstAttribute ofView:constraint.firstItem];
        } else {
            // self is common superview.
            [self removeConstraintsOfAttribute:constraint.firstAttribute ofView:constraint.firstItem];
            
//            [self removeConstraintsOfAttribute:constraint.secondAttribute ofView:constraint.secondItem];
        }
        
    } else {
        if (constraint.firstItem) {
            [self removeConstraintsOfAttribute:constraint.firstAttribute ofView:constraint.firstItem];
        } else {
            [self removeConstraintsOfAttribute:constraint.secondAttribute ofView:constraint.secondItem];
        }
    }
    
    [self addConstraint:constraint];
}

@end
