//
//  GLIMRecentChatCellTableViewCell.h
//  GLIMUI
//
//  Created by ZephyrHan on 17/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLIMSwipeableTableCell.h"
#import "GLIMImageView.h"
#import "GLIMAvatarView.h"
#import "GLIMUIUtil.h"
#import "GLIMUIMacros.h"

#define kGLMWindowWidth                         [[UIScreen mainScreen] bounds].size.width
//IMUIScreenAdapter(44)
#define kGLMRecentChatHeadImgViewHeight         [self recentChatMarginHeadHeight]

#define kGLMRecentChatMarginLeft                [self recentChatMarginLeft]
#define kGLMRecentChatMarginTop                 [self recentChatMarginTop]
#define kGLMRecentChatMarginRight               IMUIScreenAdapter(16)

#define kGLMRecentChatSpace                     IMUIScreenAdapter(12)
#define kGLMRecentChatLineSpaceLeft             IMUIScreenAdapter(16)

#define kGLMRecentChatRedLabelTopOffset         IMUIScreenAdapter(8)
#define kGLMRecentChatRedLabelRightOffset       IMUIScreenAdapter(8)
#define kGLMRecentChatRedLabelWidth             IMUIScreenAdapter(15)
#define kGLMRecentChatRedDotWidth               IMUIScreenAdapter(10)

#define kGLMRecentChatOneLetterWidth            IMUIScreenAdapter(6)

#define kGLMRecentChatTitleHeight               IMUIScreenAdapter(23)

#define kGLMRecentChatDescriptonSpaceTop        IMUIScreenAdapter(4)
#define kGLMRecentChatDescriptonHeight          IMUIScreenAdapter(16.5)

#define kGLMRecentChatTimeSpaceTop              (kGLMRecentChatMarginTop + IMUIScreenAdapter(3.5))

#define kGLMRecentChatTimeHeight                IMUIScreenAdapter(16)
#define kGLMRecentChatTimeWidth                 IMUIScreenAdapter(90)

#define kGLIMRecentChatOfficialImageViewHeight  IMUIScreenAdapter(16)
#define kGLIMRecentChatOfficialImageViewWidth   IMUIScreenAdapter(50)

#define kGLIMRecentChatCircleImageViewW         IMUIScreenAdapter(43)
#define kGLIMRecentChatCircleImageViewH         IMUIScreenAdapter(16)

#define kGLIMRecentChatOfficialImageMargin      IMUIScreenAdapter(4)

#define kGLIMRecentChatBanImageMargin           IMUIScreenAdapter(5)


#define kGLIMRecentChatShopNameMaxViewWidth     IMUIScreenAdapter(98)
#define kGLIMRecentChatShopNameViewHeight       IMUIScreenAdapter(16)
#define kGLIMRecentChatShopNameMargin           IMUIScreenAdapter(4)

#define kGLIMRecentChatBuyViewHeight            IMUIScreenAdapter(16)
#define kGLIMRecentChatBuyMargin                IMUIScreenAdapter(4)

@class GLIMChat;

@class GLIMChatUIConfig;

/// 好友Cell
@interface GLIMRecentChatCell : GLIMSwipeableTableCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) GLIMChat* chat;

@property (nonatomic, strong) GLIMChatUIConfig * config;

/// 头像视图
@property (nonatomic, strong) GLIMImageView *headImgView;
@property (nonatomic, strong) GLIMAvatarView *avatarImgView;
/// 消息未读数（带数字）
@property (nonatomic, strong) UILabel* redLabel;
/// 消息未读标识（红点）
@property (nonatomic, strong) UIView *redDotView;
/// 屏蔽标识
@property (nonatomic, strong) UIImageView *banView;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* descriptionLabel;
@property (nonatomic, strong) UILabel* timeLabel;

@property (nonatomic, strong) UILabel* fromSourceNameLab;

@property (nonatomic, strong) GLIMImageView* officialImageView;
@property (nonatomic, strong) UIImageView* maskImageView;

@property (nonatomic) BOOL formarTopStatus;

@property (nonatomic, strong) UIButton* shopNameButton;
@property (nonatomic, strong) UILabel* buyLabel;

//子账号 正在接待联系人的子账号昵称。（最多7个字，超出展示...）
@property (nonatomic, strong) UILabel* subAccountNameLab;


//，展示店铺来源。注意：网店客服视角，要在列表页和会话页展示店铺来源（APP+PC）
@property (nonatomic, strong) UILabel* fromShopNameLab;

+ (CGFloat)cellHeight;
- (CGFloat)recentChatMarginLeft;
- (CGFloat)recentChatMarginTop;
- (CGFloat)recentChatMarginHeadHeight;
- (void)setupCell ;
- (void)updateFrame;
- (void)updateCellModel;
- (void)updateLastMessageInfo;
- (void)updateLastMessageInfoWithText:(NSString *)text mmessageType:(GLIMMessageContentType )msgType;

/// 显示具体未读消息数
- (void)showRedLabelWithBadge:(NSString *)badgeString;

#pragma mark - 配置右侧按钮

/// 生成置顶按钮
- (UIButton *)topActionButton;
/// 置顶联系人操作
- (void)topChatAction;

- (UIButton *)noReadFlagActionButton;

/// 生成删除按钮
- (UIButton *)deleteActionButton;
/// 删除联系人操作
- (void)deleteChatAction;

 // 更新会话相关内容
- (void)updateChatInfo ;

 // 更新联系人相关内容
- (void)updateContactInfo;

- (void)showRedDotView;

@end
