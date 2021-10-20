//
//  GLMulColorLabel.h
//  GLUIKit
//
//  Created by Kevin on 15/10/9.
//  Copyright (c) 2015年 koudai. All rights reserved.
//


#import "GLView.h"


typedef NS_ENUM(NSUInteger, GLTextAlignment) {
    
    GLTextAlignmentLeft   = 0,
    GLTextAlignmentCenter = 1,
    GLTextAlignmentRight  = 2,
    GLTextAlignmentExpand = 3      // 两边对其
};


// ----------------------------
//
// 支持不同颜色的三段式label
//
// !!!!!!!!!!!!!!!!!!!!不建议使用 将废弃
// ----------------------------
@interface GLMulColorLabel : GLView
{
    int _width;
}

/// 头字符串
@property (nonatomic, copy) NSString *head;

/// 中字符串
@property (nonatomic, copy) NSString *mid;

/// 尾字符串
@property (nonatomic, copy) NSString *tail;

/// 对齐方式，默认左对齐
@property (nonatomic) GLTextAlignment textAlignment;



@end
