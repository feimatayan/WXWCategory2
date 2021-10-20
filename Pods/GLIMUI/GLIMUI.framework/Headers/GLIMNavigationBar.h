//
//  GLIMNavigationBar.h
//  GLIMUI
//
//  Created by huangbiao on 2018/6/19.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义导航栏，可继承该类实现扩展
 */
@interface GLIMNavigationBar : UIView

#pragma mark - 标题
/// 标题视图，如果不定制，提供默认视图
@property (nonatomic, strong) UIView *titleView;
/// 标题字符串，用于默认视图的显示
@property (nonatomic, copy) NSString *titleString;
/// 标题的颜色
@property (nonatomic, strong) UIColor *titleColor;

#pragma mark - 分隔线
/// 是否显示分隔线
@property (nonatomic, assign) BOOL needSeparator;
/// 分隔线颜色
@property (nonatomic, copy) UIColor *separatorColor;

#pragma mark - 左侧按钮
/// 左边按钮——默认回退按钮
@property (nonatomic, strong) UIButton *leftButton;
/// 回退按钮处理逻辑
@property (nonatomic, strong) dispatch_block_t leftBlock;

#pragma mark - 右侧按钮
/// 右边按钮——支持定制，默认无
@property (nonatomic, strong) UIButton *rightButton;

@end
