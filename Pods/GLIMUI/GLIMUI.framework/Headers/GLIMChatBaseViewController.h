//
//  GLIMChatBaseViewController.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/23.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <GLIMSDK/GLIMSDK.h>
#import "GLIMBaseViewController.h"
#import "GLIMMessageCellCache.h"
#import "GLIMMessageCellFactory.h"
#import "GLIMChatTabExtendData.h"

/*
 所有聊天页面的基类
 提供公共的对外属性
 公共UI
 */
@interface GLIMChatBaseViewController : GLIMBaseViewController
{
    GLIMChat                * _chat;
    GLIMChatSource          * _chatSource;
    NSMutableDictionary     * _imageSourceDic;
    NSMutableArray          * _soundMessages;
    GLIMMessageCellCache    * _cellCache;
    UITableView             * _messageListView;
    UIActivityIndicatorView * _loadingView;
    BOOL                    _loadMoreOver;
    CGFloat                 _offsetY;
    GLIMMessageCellFactory  * _cellFactory;
    GLIMMessageKeeper       * _messageKeeper;
    GLIMMessage             * _sendMessage;
}

//公共对外属性
//messageList的数据源
@property (nonatomic,strong) GLIMMessageKeeper * messageKeeper;
// 用于显示在messageList里的 特型消息 如发送商品
@property (nonatomic, strong) GLIMMessage * sendMessage;
// 联系人对象 联系人所带的chatSource用于显示在页面顶部
@property (nonatomic, strong) GLIMChat * chat;
// 外面传过来的chatSource 用于发送
@property (nonatomic, strong) GLIMChatSource * chatSource;

//公共页面属性
//cell工厂
@property (nonatomic, strong) GLIMMessageCellFactory *cellFactory;
//cell缓存
@property (nonatomic, strong) GLIMMessageCellCache *cellCache;
//mainView
@property (nonatomic, strong) UIScrollView *mainView;
//tableview
@property (nonatomic, strong) UITableView *messageListView;

@property (nonatomic, strong) UIView *tapsBottomView;

//顶部的loading
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
//因为顶部加载更多 是监控的scroll滚动 数据返回更新tableview过程中 还是会不断出发 加载更多 故加此bool值
@property (nonatomic, assign) BOOL loadMoreOver;
// 向下滑动加载更多消息
@property (nonatomic, assign) BOOL loadMoreDownOver;
//记住当前tableview的offset 用于下拉刷新
@property (nonatomic, assign) CGFloat offsetY;
//自定义导航右侧按钮点击事件
@property (nonatomic, copy) void(^rightCallBack)(id obj);
//自定义导航左侧按钮点击事件
@property (nonatomic, copy) void(^leftCallBack)(id obj);
//点击返回时候要关闭当前聊天 YES关闭 NO不关闭
//id obj 当前的控制器
@property (nonatomic, copy) BOOL(^isCanBackCurrentChatCallBack)(id obj);

//群扩展信息
@property (nonatomic, copy) NSString *extendInfos;

//键盘收起和展开的回调 回调键盘的高度
@property (nonatomic, copy) BOOL(^bottomViewDidChangedCallBack)(NSUInteger bottomViewHeight);

- (void)addRightBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)addRightBarButtonItems:(NSArray *)barButtonItems;

- (void)addLeftBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)rightBarButtonPress:(id)obj;

- (void)leftBarButtonPress:(id)obj;

/**
 添加at某人

 @param someone 具体的用户，目前只支持群成员(GLIMGroupMember)，如果传入其他类型的数据则不做任何处理
 */
- (void)addAtSomeoneWithObj:(id)someone;


- (void)addWelcomePersionWithObj:(id)someone;


#pragma mark - 外部扩展业务，适用于进入聊天页面后立即需要处理的外部业务，如回访消息
/**
 外部带过来的业务数据，具体格式如下：
 {
 @"type":业务类型，如101-回访消息
 @"data":@{具体业务数据}
 }
 */
@property (nonatomic, strong) NSDictionary *businessDict;

/**
 处理扩展业务
 */
- (void)handleExtendBussiness;


#pragma mark - 曝光相关
//- (void)exposureWhenScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//- (void)exposureWhenScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
//- (void)exposureWhenScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (void)exposureWhenScrollViewDidScroll:(UIScrollView *)scrollView;


//添加视图的标题和视图 一一对应
- (void)addChatTabViewWithTitles:(NSArray *)titles withViews:(NSArray *)views;
- (void)addChatTabExtendData:(GLIMChatTabExtendData *)chatTabExtendData;
- (BOOL)isCanShowChatTabView;
- (void)bottomViewResignBottomFirstResponder;

@end
