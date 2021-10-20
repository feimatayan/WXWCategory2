//
//  GLSelectTabBar.h
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 30/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLView.h"
#import "GLSelectTabBarData.h"

typedef NS_ENUM (NSUInteger, GLSelectTabBarUnReadNumStyle) {
    GLSelectTabBarUnReadNumStylePoint = 0,
    GLSelectTabBarUnReadNumStyleNum   = 1
};

typedef NS_ENUM (NSInteger, GLSelectTabBarBtnTheme) {
    GLSelectTabBarBtnThemeNormal = 0
};

@class GLSelectTabBar;

/**
 数据源协议
 */
@protocol GLSelectTabBarDataSource <NSObject>

/**
 获取数据源行数大小

 @param selectTabBar selectTabBar
 @return 行数
 */
- (NSUInteger)numberOfSelectTabBar:(GLSelectTabBar *)selectTabBar;

/**
 装配数据源

 @param selectTabBar selectTabBar
 @param index index
 @return 返回数据源
 */
- (GLSelectTabBarData *)selectTabBar:(GLSelectTabBar *)selectTabBar dataSourceForIndex:(NSUInteger)index;

/**
 未读数类型

 @param selectTabBar selectTabBar
 @param index index
 @return 类型
 */
- (GLSelectTabBarUnReadNumStyle)selectTabBar:(GLSelectTabBar *)selectTabBar unReadNunTypeForIndex:(NSUInteger)index;

/**
 未读数最大值限制

 @param selectTabBar selectTabBar
 @param index index
 @return 限制
 */
- (NSUInteger)selectTabBar:(GLSelectTabBar *)selectTabBar limitUnReadNumForIndex:(NSUInteger)index;

/**
 未读数

 @param selectTabBar selectTabBar
 @param index index
 @return 如果类型为 GLSelectTabBarUnReadNumStylePoint ：需要红点则返回>0 数据。 不显示红点返回0
            如果类型为 GLSelectTabBarUnReadNumStyleNum： 需要显示未读数 则返回>0 数据，不显示未读数则返回0；
 */
- (NSUInteger)selectTabBar:(GLSelectTabBar *)selectTabBar unReadNumForIndex:(NSUInteger)index;

@end

/**
 操作协议
 */
@protocol GLSelectTabBarDelegate <NSObject>

/**
 tabbar 点击选择

 @param selectTabBar selectTabBar
 @param index index
 */
- (void)selectTabBar:(GLSelectTabBar *)selectTabBar didClickSelectTabBar:(NSInteger)index;

@end

/**
 顶部导航栏
 */
@interface GLSelectTabBar : GLView

/// dataSource
@property (nonatomic, weak) id<GLSelectTabBarDataSource> dataSource;

/// delegate
@property (nonatomic, weak) id<GLSelectTabBarDelegate> delegate;

/// 按钮主题
@property (nonatomic, assign) GLSelectTabBarBtnTheme theme;

@property (nonatomic, assign) BOOL showBottomSeparator;



- (instancetype)initWithFrame:(CGRect)frame;

/**
 重新加载数据
 */
- (void)reloadData;

/**
 隐藏index位置的未读状态

 @param index index
 */
- (void)showUnReadStatusAtIndex:(NSInteger)index forNum:(NSUInteger)num;

/**
 切换tabbar

 @param index index
 */
- (void)switchTabBarAtIndex:(NSUInteger)index;
@end
