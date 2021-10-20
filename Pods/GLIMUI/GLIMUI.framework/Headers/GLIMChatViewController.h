//
//  GLIMChatViewController.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GLIMChatBaseViewController.h"
#import "GLIMMessageBottomView.h"
#import "GLIMChatTitleView.h"

/// 未读消息数超过10条才显示右上角的未读消息视图
#define kGLIMGroupChatUnreadMessageCountLimit   10
#define kGLIMGLIMChatViewControllerSearchModelMessageCountLimit 30
//全量拒绝含有input 单词关键字的类的引入 和 生成含有input 单词的成员变量！！！！
//会和系统的minuView冲突
@interface GLIMChatViewController : GLIMChatBaseViewController<GLIMDataKeeperDelegate> {
}
@property (nonatomic,weak) GLIMMessageKeeper * currentMessageKeeper;

/// 数据加载队列（串行）
@property (nonatomic, copy) dispatch_queue_t loadDataQueue;

/// 标题视图（原本放到内部的，考虑到买家版定制时需要使用标题视图，所以放到外部）
@property (nonatomic, strong) GLIMChatTitleView *chatTitleView;

/// 底部视图
@property (nonatomic, weak) GLIMMessageBottomView *bottomView;

/// 底部蒙层
@property (nonatomic, weak) UIView *bottomMaskView;

@property (nonatomic, assign) BOOL needMoveNav;

//标识当前页面是什么视图 浏览视图和收发消息视图
@property (nonatomic, assign) BOOL isSearchShowModel;
@property (nonatomic, assign) BOOL isSearchShowModelFirstEnter;

//群成员 是否在群聊 YES在群聊 NO不在群聊
@property (nonatomic, assign) BOOL memberInGroup;

//群是不是有效 解散了么
// 默认为 NO 没解散
@property (nonatomic, assign) BOOL isGroupDissolution;

/**
 根据聊天类型生成聊天会话页面

 @param chatType 聊天类型
 @return 会话页面
 */
+ (instancetype)chatViewControllerWithChatType:(GLIMChatType)chatType;

/**
 根据聊天对象生成聊天会话页面

 @param chat 聊天对象
 @return 会话页面
 */
+ (instancetype)chatViewControllerWithChat:(GLIMChat *)chat;

- (void)reloadData;

- (void)popToFrontViewController;

#pragma mark -
@property (nonatomic, assign) BOOL isShortcutReply;
@property (nonatomic, strong) UIView *maskView;

- (void)configShortcutReplyTitleView;

/**
  显示红包引导浮层
 */
- (void)showRedPacketBootView;

- (void)showToolTipsViewView;

/// 提供快捷回复时直接关闭快捷回复页面的接口
- (void)closeShortcutViewWhenShortcut;

//更新宽度
- (void)updateTitleViewLRWidth:(CGFloat)lrWidth;

//点击 title
@property (nonatomic, copy) void(^titleCallBack)(id obj);

@end
