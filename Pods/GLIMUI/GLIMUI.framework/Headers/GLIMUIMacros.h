//
//  GLIMUIMacros.h
//  GLIMUI
//
//  Created by ZephyrHan on 17/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#ifndef GLIMUIMacros_h
#define GLIMUIMacros_h


#import "GLIMDeviceMacros.h"
#import "GLIMUIUtil.h"

#pragma mark - 颜色

#define UIColorFromRGB(rgbValue)                [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define UIColorRGB(r, g, b)                     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define UIColorRGB_A(r, g, b, a)                [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#pragma mark - 字体

#define FONT_WITH_SIZE(size)                    ([UIFont systemFontOfSize:(size)])
#define BOLD_FONT_WITH_SIZE(size)               ([UIFont boldSystemFontOfSize:(size)])


#pragma mark - 尺寸
#import "GLIMUtils.h"
#define UIScreenAdapter(point)                   IMUIScreenAdapter(point)
#define UIFontAdapter(fontSize)                  IMUIFontAdapter(fontSize)
#define UIScreenDefaultBorder                   ((SCREEN_SCALE == 1.0) ? 1.0 : ((SCREEN_SCALE == 3.0) ? 0.35 : 0.5))
#define GLIMUIScreenAdapter_W(a) [UIScreen mainScreen].bounds.size.width*((a)/375.0)
#define GLIMUIScreenAdapter_H(b) [UIScreen mainScreen].bounds.size.width*((b)/375.0)
#define GLIMUIScreenAdapter_Scale ([UIScreen mainScreen].bounds.size.width/375.0)

#endif /* GLIMUIMacros_h */
