//
//  WDIEDrawLineInfo.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDIEDrawLineInfo : UIView

//线条所包含的所有点
@property (nonatomic,strong) NSMutableArray <__kindof NSValue *>*linePoints;

//线条的颜色
@property (nonatomic,strong) UIColor *lineColor;

//线条的粗细
@property (nonatomic, assign) CGFloat lineWidth;

@end
