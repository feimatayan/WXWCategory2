//
//  GLDraggableButton.m
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLDraggableButton.h"


@interface GLDraggableButton()

@property (nonatomic, copy) dispatch_block_t tapEventBlock;

@property (nonatomic, assign) BOOL tapIsValid;

@end


@implementation GLDraggableButton
{
    CGPoint beginPoint;
}

- (void)addTapEventCallBack:(dispatch_block_t)block
{
    self.tapEventBlock = block;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (!_isDraggable) {
        return ;
    }
    beginPoint = [[touches anyObject] locationInView:self];
    self.tapIsValid = YES;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    self.tapIsValid = NO;
    
    if (!_isDraggable) {
        return ;
    }
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self];
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    //回调
    if (_tapIsValid) {
        if (_tapEventBlock) {
            _tapEventBlock();
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.tapIsValid = NO;
    
}

@end
