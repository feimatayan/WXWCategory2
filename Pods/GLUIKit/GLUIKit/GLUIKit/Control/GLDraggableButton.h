//
//  GLDraggableButton.h
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//




#import "GLButton.h"


/************************
 *
 * 可拖拽按钮
 *
 ***********************/
@interface GLDraggableButton : GLButton

/// 是否开启拖拽
@property (nonatomic, assign) BOOL isDraggable;

- (void)addTapEventCallBack:(dispatch_block_t)block;

@end
