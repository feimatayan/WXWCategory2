//
//  UIColor+GLIMTool.h
//  GLIMUI
//
//  Created by jiakun on 2019/1/3.
//  Copyright © 2019年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (GLIMTool)

+ (UIColor *)glim_colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)glim_colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
