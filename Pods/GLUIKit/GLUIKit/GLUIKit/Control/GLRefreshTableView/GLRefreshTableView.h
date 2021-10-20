//
//  SyTableView.h
//  Dajia
//
//  Created by zhengxiaofeng on 13-7-5.
//  Copyright (c) 2013年 zhengxiaofeng. All rights reserved.
//



#import "GLView.h"



@class GLTableView;
@class GLButton;
@protocol GLRefreshTableViewDelegate;
@protocol GLRefreshTableViewDataSource;

@interface GLRefreshTableView : GLView<UITableViewDataSource,UITableViewDelegate>

/// TableView DataSource
@property (nonatomic, weak) id<GLRefreshTableViewDataSource> dataSource;

/// TableView and GLRefreshTableView delegate
@property (nonatomic, weak) id<UITableViewDelegate,GLRefreshTableViewDelegate>   delegate;

/// real TableView
@property (nonatomic, retain) GLTableView   *tableView;
/// 在刷新中 flag 
@property (nonatomic, assign) BOOL          isRefresh;



/**
 *  实例一个 GLRefreshTableView
 *
 *  @param frame tableView frame
 *  @param style tableView style
 *  
 *  if you want creat a UITableViewStyleGrouped,you can use this.
 *
 *  @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;


/**
 *  @brief  添加 头部刷新
 */

- (void)setupTableHeaderView;


/**
 *  @brief  移除 头部刷新
 */
- (void)disableTableHeaderView;



/**
 *  @brief  添加 底部刷新
 */
- (void)setupTableFooterView;


/**
 *  @brief  移除 底部刷新
 */
- (void)disableTableFooterView;


/**
 *  @brief  同时添加 头部&底部 刷新
 */
- (void)setupTableHeaderAndTableFooterView;



/**
 *  @brief  展开下拉加载
 */
- (void)showHeadLoading;

/**
 *  @brief  收起下拉加载
 */

- (void)hideHeadLoading;


/**
 *  @brief reload tableView
 */
- (void)reloadData;

/**
 *
 *  @brief reload tableView 同时重置 下拉刷新、上拉翻页
 */

- (void)reloadDataAndReset;


/**
 *  @brief 同时重置 下拉刷新、上拉翻页
 */
- (void)resetTableHeaderAndTableFooterView;


/**
 *  @brief 重置 HeaderView
 */
- (void)resetTableHeaderView;

/**
 *  @brief 重置 FooterView
 */
- (void)resetTableFooterView;

/**
 *  @brief NoData 显示 已经到最后了
 *  1.此时 tableviewFooterRefresh:不可用
 */
- (void)updateFootViewNoData;


@end






#pragma mark- protocol

@protocol GLRefreshTableViewDelegate <UITableViewDelegate>




@optional




/**
 *  @brief  下拉“刷新”函数响应
 */
- (void)tableViewHeaderReresh:(GLRefreshTableView *)tableView;

/**
 *  @brief  上拉“翻页”函数响应
 */
- (void)tableviewFooterRefresh:(GLRefreshTableView *)tableView;



@end


@protocol GLRefreshTableViewDataSource<UITableViewDataSource>



@end





