//
//  SyTableHeaderView.h
//  Dajia
//
//  Created by zhengxiaofeng on 13-7-8.
//  Copyright (c) 2013年 zhengxiaofeng. All rights reserved.
//





#import "GLView.h"





typedef NS_ENUM(NSInteger, GLRefreshTableHeaderViewStyle) {
    GLRefreshTableHeaderViewStylePull,          // 下拉
    GLRefreshTableHeaderViewStyleRelease,       // 松开
    GLRefreshTableHeaderViewStyleLoading        // 加载中
};






@interface GLRefreshTableHeaderView : GLView 


/// 当前使用的 style
@property (nonatomic, assign) GLRefreshTableHeaderViewStyle      currentStyle;

/**
 *  @brief 更新状态
 *
 *  @param style 状态参数
 */
- (void)updateStyle:(GLRefreshTableHeaderViewStyle)style;
/**
 *  @brief 显示加载 漏出 headveiw
 *
 *  @param tableView UITableView
 *  @param animated  动画flag
 */
- (void)startLoading:(UITableView *)tableView animated:(BOOL)animated;

/**
 *  @brief 结束加载 并隐藏 headView
 *
 *  @param tableView UITableView
 *  @param animated  动画flag
 */
- (void)finishLoading:(UITableView *)tableView animated:(BOOL)animated;


@end



