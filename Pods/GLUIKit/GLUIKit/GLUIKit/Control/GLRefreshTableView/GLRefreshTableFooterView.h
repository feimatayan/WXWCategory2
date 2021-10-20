//
//  SyTableFooterView.h
//  Dajia
//
//  Created by zhengxiaofeng on 13-7-8.
//  Copyright (c) 2013年 zhengxiaofeng. All rights reserved.
//







#import "GLControl.h"






typedef NS_ENUM(NSInteger, GLRefreshTableFooterViewStyle) {
    GLRefreshTableFooterViewPull,                   // 默认状态
    GLRefreshTableFooterViewRelease,                // release
    GLRefreshTableFooterViewLoading,                // 加载中
    GLRefreshTableFooterViewNoData                  // 没有数据了
};








@interface GLRefreshTableFooterView :  GLControl 



/// 当前展示样式
@property (nonatomic, assign) GLRefreshTableFooterViewStyle     currentStyle;



/**
 *  @brief 填充view 的展示样式
 *
 *  @param style 样式
 */
- (void)updateStyle:(GLRefreshTableFooterViewStyle)style;


@end

