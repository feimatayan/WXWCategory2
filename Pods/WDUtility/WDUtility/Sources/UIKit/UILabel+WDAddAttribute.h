//
//  UILabel+WDAddAttribute.h
//  WDUtility
//
//  Created by yuping on 16/5/12.
//  Copyright © 2016年 yuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WDAddAttribute)

/**
 * label添加删除线
 */
- (void)wd_addDeleteLine;

/**
 * label添加删除线
 */
- (void)wd_addDeleteLineWithColor:(UIColor *)color;

-(void)wd_alignTopWithAttributeDic:(NSDictionary *)attributeDic;

@end
