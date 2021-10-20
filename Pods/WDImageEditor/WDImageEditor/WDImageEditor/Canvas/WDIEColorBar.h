//
//  WDIEColorBar.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WDIESelectedColorBlock)(UIColor *color, NSUInteger index);

/**
 颜色选择器
 */
@interface WDIEColorBar : UIView

// 选中颜色后的回调
@property (nonatomic, copy) WDIESelectedColorBlock selectedColorBlock;

// 边颜色 默认为白色#FFFFFF
@property (nonatomic, strong) UIColor *borderColor;

// 被选择的按钮下标 从0开始计算
@property (nonatomic, assign) NSUInteger selectedIndex;

// 被选择的颜色
@property (nonatomic, strong, readonly) UIColor *selectedColor;

// 默认 白、黑、红、黄、绿、蓝、紫、粉 8种颜色
@property (nonatomic, copy) NSArray<UIColor *> *colors;

- (instancetype)initWithColors:(NSArray<UIColor *> *)colors;

@end
