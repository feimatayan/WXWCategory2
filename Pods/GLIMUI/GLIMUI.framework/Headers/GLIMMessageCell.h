//
//  GLIMMessageCell.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMUIMacros.h"
#import "GLIMMessageStatusView.h"
#import "GLIMMenuView.h"
#import "GLIMImageView.h"
#import "GLIMMessageTapInfo.h"
#import "GLIMMessageCellCache.h"

@class GLIMMessageUIConfig;

//缓存相关key
#define GLIMCellCacheCellSize           @"cellSize"
#define GLIMCellCacheContentDic         @"contentDic"
#define GLIMCellCacheContentSize        @"contentSize"

//间距相关key
#define GLIMCellPadding                 UIScreenAdapter(3)
//content上下边距
#define GLIMTextContentTopPadding       UIScreenAdapter(10)
//content左右边距
#define GLIMContentToEdgePadding        UIScreenAdapter(12)

//content最大宽度
#define GLIMContentMaxWidth             ([[UIScreen mainScreen] bounds].size.width - UIScreenAdapter(120))
//cell宽度
#define GLIMCellWidth                   [[UIScreen mainScreen] bounds].size.width
//气泡最小宽度
#define GLIMBubbleMinWidth              UIScreenAdapter(40)
//气泡箭头宽度
#define GLIMBubbleArrowWidth            UIScreenAdapter(0)

// 气泡上边距
#define GLIMBubbleTopPadding            UIScreenAdapter(5)//4
// 气泡下边距
#define GLIMBubbleBottomPadding         UIScreenAdapter(5)//15

//cell最小高度
#define GLIMCellMinHeight               (UIScreenAdapter(40) + GLIMBubbleTopPadding +GLIMBubbleBottomPadding)
//cell最小宽度
#define GLIMCellMinWidth                UIScreenAdapter(55)

// 头像距离气泡间距
#define GLIMChatAvatarToBubbleDelta     IMUIScreenAdapter(10)

//群精华高度
#define GLIMChatgroupEssenceViewH     IMUIScreenAdapter(21)

@class GLIMMessageCell;

@protocol GLIMMessageCellDelegate <NSObject>

@optional
- (void)didTapMessageCell:(GLIMMessageCell *)cell;

//cell 是否支持自己显示昵称 默认为NO
- (BOOL)isSupportMySelfShowName;

//cell 的内容是否支持撤回 默认为NO
- (BOOL)isSupportShowRedraw;

//cell 自己的头像是否支持点击 默认为YES
- (BOOL)isSupportMyselfAvatarClickWithMessage:(GLIMMessage *)message;

/// 是否支持所有头像点击事件
- (BOOL)isSupportAllAvatarClickWithMessage:(GLIMMessage *)message;

//cell 显示当前播放的设备
- (void)showCurrentPlayEquipmentUI;

//cell 是否支持删除消息
- (BOOL)isSupportDeleteMessage;

/**
 如果消息Cell是在快捷回复页面，则单击Cell之前需要关闭快捷回复页面
 */
- (void)closeShortcutViewBeforeTapCell;

@end

/*聊天cell基类
 */
@interface GLIMMessageCell : UITableViewCell<GLMMessageStatusViewDelegate,GLIMMenuViewDelegate,GLIMMenuViewDataSource>{
    GLIMMessage * _message;
    __weak id<GLIMMessageCellDelegate> _delegate;
}
//cell配置config
@property (nonatomic,strong)GLIMMessageUIConfig * config;

//cell点击事件对象
@property (nonatomic,strong)GLIMMessageTapInfo * tapInfo;

//cell点击事件传递
@property (nonatomic,weak) id<GLIMMessageCellDelegate> delegate;

//message
@property (nonatomic,strong) GLIMMessage * message;

/// 消息是否是自己发的
@property (nonatomic, assign) BOOL isFromSelf;

//关联的联系人
@property (nonatomic,strong) GLIMChat *chat;

/// 头像view
@property (nonatomic, strong) GLIMImageView *avatarView;

/// 名称Labal
@property (nonatomic, strong) UILabel *nameLabel;

/// 子类需关心的显示内容的view
@property (nonatomic, strong) UIView *chatContentView;

/// cell气泡view
@property (nonatomic, strong) UIImageView *chatBubbleView;

/// 是否启用contentView的点击事件，默认NO
@property (nonatomic, assign) BOOL enableTapContentRecognizer;

/// 消息状态view
@property (nonatomic, strong) GLIMMessageStatusView *statusView;

//menu菜单
@property (nonatomic, strong) GLIMMenuView *menuView;

/// 当前消息群成员身份
@property (nonatomic, assign) NSInteger groupMemberIdentity;

@property (nonatomic, strong) UILabel * statusLabel;


@property (nonatomic, strong) UIView * groupEssenceView;
@property (nonatomic, strong) UILabel * groupEssenceView_titleLab;
@property (nonatomic, strong) UIImageView * groupEssenceView_icon;

//初始化需赋值message 否则无法判断是否自己的消息
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(GLIMMessage *)message;

//子类自己处理contentView
- (void)setupContentView:(UIView *)contentView;

- (void)setupGroupEssenceFrame:(UIView *)view leftX:(CGFloat)leftX;

//数据源赋值后重新布局 子类需在数据源赋值后主动调用
- (void)reLayoutSubviews;

//整个cell点击事件  子类自己处理
- (void)didTapCell:(UITapGestureRecognizer *)recognizer;

- (void)cleanCell;

/// 气泡背景图
- (UIImage *)selfBubbleImage;
- (UIImage *)otherBubbleImage;

#pragma mark - 统计相关
/// 上报曝光日志
- (void)logExposure;

#pragma mark - 类方法
+ (NSDictionary *)sizeForSelfContent:(GLIMMessage *)message;

/**
 计算单聊消息Cell的完整尺寸
 子类无需关心此方法，除非布局发生大的变化
 
 @param message 消息数据
 @param contentSize 消息内容的显示尺寸
 @return 完整的消息尺寸
 */
+ (CGSize )sizeForSelf:(GLIMMessage *)message
       withContentSize:(CGSize)contentSize;

/**
 计算Cell的完整尺寸
 子类无需关心此方法，除非布局发生大的变化
 
 @param message 消息数据
 @param contentSize 消息内容的显示尺寸
 @param chatType 聊天类型
 @return 完整的消息尺寸
 */
+ (CGSize )sizeForSelf:(GLIMMessage *)message
       withContentSize:(CGSize)contentSize
              chatType:(GLIMChatType)chatType;


/**
 计算Cell的完整尺寸
 子类无需关心此方法，除非布局发生大的变化
 
 @param message 消息数据
 @param contentSize 消息内容的显示尺寸
 @param chatType 聊天类型
 @param delegate 聊天页面的实例
 @return 完整的消息尺寸
 */
+ (CGSize )sizeForSelf:(GLIMMessage *)message
       withContentSize:(CGSize)contentSize
              chatType:(GLIMChatType)chatType
              delegate:(id<GLIMMessageCellCacheDelegate> )delegate;

@end
