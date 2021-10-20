//
// Created by reeceran on 16/5/5.
// Copyright (c) 2016 Henson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define WDColorWithRGBA(RED, GREEN, BLUE, ALPHA)      [UIColor colorWithRed:RED/255.0 \
                                                                      green:GREEN/255.0 \
                                                                       blue:BLUE/255.0 \
                                                                      alpha:ALPHA]

#define WDColorWithRGB(RED, GREEN, BLUE)               WDColorWithRGBA(RED,GREEN,BLUE,1.0)

#define WDColorWithRGB0X(rgbValue)                     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                                       green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                                        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (WDUIKit)


@end
