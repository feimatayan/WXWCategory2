//
//  GLPageSwitch.h
//  WDCommlib
//
//  Created by smallsao on 15/12/17.
//  Edit By HTHorizontalSelectionList.h
//  Copyright © 2015年 赵 一山. All rights reserved.
//


#import "GLView.h"







/************
 
 // page 选择器 demo
 NSArray *pItems = @[@"全部",@"收入",@"支出",@"冻结/解冻",@"全部",@"收入",@"支出",@"冻结/解冻"];
 self.pageSwitchView = [[GLPageSwitch alloc] initByAutolayoutWithSpaceStyle:GLPageSwitchSpaceStyleAutoWidthWithScroll];
 self.pageSwitchView.bottomTrimColor = UIColorFromRGB(0xe5e5e5);
 self.pageSwitchView.backgroundColor = UIColorFromRGB(0xf7f7f7);
 self.pageSwitchView.selectionIndicatorColor = UIColorFromRGB(0xc21525);
 self.pageSwitchView.items = pItems;
 self.pageSwitchView.selectedButtonIndex = 0;
 self.pageSwitchView.buttonWidth = 80 ;
 self.pageSwitchView.delegate = self;
 [self.view addSubview:self.pageSwitchView];
 [self.pageSwitchView setTranslatesAutoresizingMaskIntoConstraints:NO];
 
************/

/**
 *  @author smallsao, 15-12-17 
 *
 *  按钮布局方式
 */
typedef NS_ENUM(NSInteger, GLPageSwitchSpaceStyle) {
    /**
     *  @author smallsao, 15-12-17 16:12:40
     *
     *  定宽 （所有按钮宽度一致）
     */
    GLPageSwitchSpaceStyleFixedWidth = 0,
    /**
     *  @author smallsao, 15-12-17 16:12:40
     *
     *  自动宽度（根据文字宽度）超出带滚动
     */
    GLPageSwitchSpaceStyleAutoWidthWithScroll,
    /**
     *  @author smallsao, 15-12-17 16:12:40
     *
     *  自动宽度 (所有布局之和不能超出屏幕宽度）自适应大小
     */
    GLPageSwitchSpaceStyleAutoWidthNoScroll
};

/**
 *  @author smallsao, 15-12-17 17:12:14
 *
 *  选中类型
 */
typedef NS_ENUM(NSInteger, GLPageSwitchDisplayStyle) {
    /**
     *  @author smallsao, 15-12-17 17:12:14
     *
     *  下边横线展示
     */
    GLPageSwitchDisplayStyleBottomBar, // Default
    /**
     *  @author smallsao, 15-12-17 17:12:14
     *
     *  选中框展示
     */
    GLPageSwitchDisplayStyleButtonBorder
};

@protocol GLPageSwitchDelegate;

@interface GLPageSwitch : GLView

/// 当前选择的button Index
@property (nonatomic) NSInteger selectedButtonIndex;

/// 控件代理
@property (nonatomic, weak) id<GLPageSwitchDelegate> delegate;

/// 按钮标题组
@property (nonatomic, strong) NSArray *items;

/// 选择颜色
@property (nonatomic, strong) UIColor *selectionIndicatorColor;

/// 下端指示颜色
@property (nonatomic, strong) UIColor *bottomTrimColor;

/// 未读数字背景颜色
@property (nonatomic, strong) UIColor *unreadNumBGColor;

/// 未读数字文字颜色
@property (nonatomic, strong) UIColor *unreadNumTitleColor;

/// 红点图片
@property (nonatomic, strong) UIImage *redPointImage;

/// button margin
@property NSInteger btnMargin;

@property (nonatomic) UIEdgeInsets buttonInsets;

/// 展示方式
@property (nonatomic) GLPageSwitchDisplayStyle displayStyle;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

- (void)reloadData;

/**
 *  @author smallsao, 15-12-17 15:12:34
 *
 *  use frame
 *
 *  @param frame      frame
 *  @param spaceStyle 控件展示类型
 *
 *  @return id
 */
- (id)initByFrame:(CGRect)frame withSpaceStyle:(GLPageSwitchSpaceStyle)spaceStyle;

/**
 *  @author smallsao, 15-12-17 15:12:41
 *
 *  use autolayout
 *
 *  @param spaceStyle 控件展示类型
 *
 *  @return id
 */
- (id)initByAutolayoutWithSpaceStyle:(GLPageSwitchSpaceStyle)spaceStyle;

/**
 *  @author smallsao, 16-01-12 12:01:32
 *
 *  @brief 切换至某个页面
 *
 *  @param page page
 */
- (void)switchToPage:(NSInteger)page;


/**
 *  @author smallsao, 16-01-13 11:01:44
 *
 *  @brief 显示未读数
 *
 *  @param num  未读数
 *  @param page 页码
 */
- (void)showUnreadStatusWithNum:(NSInteger)num forPageIndex:(NSInteger)page;

/**
 *  @author smallsao, 16-01-13 11:01:11
 *
 *  @brief 显示红点
 *
 *  @param page 页码
 */
- (void)showUnreadStatusWithRedPointForPage:(NSInteger)page;


/**
 *  @author smallsao, 16-01-13 11:01:34
 *
 *  @brief 隐藏未读状态显示
 *
 *  @param page 页码
 */
- (void)hideUnreadStatusForPage:(NSInteger)page;

/**
 *  @author smallsao, 16-01-15 16:01:23
 *
 *  @brief 立刻刷新展示 pageSwitch
 */
- (void) display;

@end

@protocol GLPageSwitchDelegate <NSObject>

- (void)selectionList:(GLPageSwitch *)pageSwitch didSelectButtonWithIndex:(NSInteger)index;



@end
