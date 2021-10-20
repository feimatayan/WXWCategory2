//
//  WDIETranslucentView.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/3/6.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 渐变透明
 */
@interface WDIETranslucentView : UIView

/**
 初始化渐变视图

 * The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable.
 
 @param startPoint 向量起点
 @param endPoint   向量终点
 @return 渐变视图
 */
- (instancetype)initWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint;

@end
