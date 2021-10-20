//
//  GLIMUI.h
//  GLIMUI
//
//  Created by ZephyrHan on 17/3/18.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GLIMUI.
FOUNDATION_EXPORT double GLIMUIVersionNumber;

//! Project version string for GLIMUI.
FOUNDATION_EXPORT const unsigned char GLIMUIVersionString[];

#import <GLIMUI/GLIMRecentChatsListController.h>
#import <GLIMUI/GLIMRecentChatsCollectionListController.h>

#import <GLIMUI/GLIMChatBaseViewController.h>
#import <GLIMUI/GLIMChatViewController.h>
#import <GLIMUI/GLIMChatHistoryViewController.h>
#import <GLIMUI/GLIMChatTabExtendData.h>

#import <GLIMUI/GLIMChatSourceManager.h>
#import <GLIMUI/GLIMChatSourceView.h>

#import <GLIMUI/GLIMUtils.h>
#import <GLIMUI/GLIMUIUtil.h>
#import <GLIMUI/GLIMDeviceMacros.h>
#import <GLIMUI/GLIMUIMacros.h>
#import <GLIMUI/UIView+GLIMFrame.h>
#import <GLIMUI/UIColor+GLIMTool.h>


#import <GLIMUI/GLIMUIConfig.h>
#import <GLIMUI/GLIMUIInterface.h>
#import <GLIMUI/GLIMUIDefine.h>

#import <GLIMUI/GLIMAlertHelper.h>
#import <GLIMUI/GLIMUIToastView.h>


/// 联系人列表
#import <GLIMUI/GLIMChatUIProtocol.h>
#import <GLIMUI/GLIMChatUIConfig.h>
#import <GLIMUI/GLIMRecentChatCellFactory.h>
#import <GLIMUI/GLIMSwipeableTableCell.h>
#import <GLIMUI/GLIMRecentChatCell.h>

/// 聊天页面标题
#import <GLIMUI/GLIMChatTitleView.h>

/// 聊天页面消息Cell
#import <GLIMUI/GLIMMessageUIProtocol.h>
#import <GLIMUI/GLIMMessageCellFactory.h>
#import <GLIMUI/GLIMMessageCell.h>
#import <GLIMUI/GLIMMessageCellCache.h>
#import <GLIMUI/GLIMMessageUIConfig.h>
#import <GLIMUI/GLIMMessageTextConfig.h>
#import <GLIMUI/GLIMMessageSystemConfig.h>
#import <GLIMUI/GLIMUIMessageContentParser.h>

/// 聊天页面底部栏
#import <GLIMUI/GLIMMessageBottomProtocol.h>
#import <GLIMUI/GLIMMessageBottomView.h>
#import <GLIMUI/GLIMMessageBottomActionConfig.h>
#import <GLIMUI/GLIMMessageBottomActionItemData.h>
#import <GLIMUI/GLIMMessageBottomImageItemData.h>
#import <GLIMUI/GLIMMessageBottomQuickReplyItemData.h>
#import <GLIMUI/GLIMMessageBottomVideoItemData.h>
#import <GLIMUI/GLIMImageProcesser.h>

/// 聊天页面业务扩展
#import <GLIMUI/GLIMChatViewBusinessManager.h>
#import <GLIMUI/GLIMMessageBottomExtendView.h>

#import <GLIMUI/GLIMMenuView.h>
#import <GLIMUI/GLIMMessageStatusView.h>
#import <GLIMUI/GLIMImageView.h>
#import <GLIMUI/GLIMAvatarView.h>
#import <GLIMUI/GLIMMessageTapInfo.h>
#import <GLIMUI/GLIMEmptyResultView.h>

#import <GLIMUI/GLIMVoipManager.h>
#import <GLIMUI/GLIMShareChatViewController.h>

/// 最近联系人列表扩展
#import <GLIMUI/GLIMRecentExtensibleManager.h>
#import <GLIMUI/GLIMRecentExtensibleCell.h>
#import <GLIMUI/GLIMRecentExtensibleData.h>
#import <GLIMUI/GLIMMoreRecentChatExtensibleManager.h>

#import <GLIMUI/NSString+GLIM.h>
#import <GLIMUI/UIView+GLIMFrame.h>

/// 聊天顶部扩展
#import <GLIMUI/GLIMChatTopBaseView.h>
#import <GLIMUI/GLIMChatListTopViewBaseView.h>


/// 最近联系人列表底部扩展
#import <GLIMUI/GLIMTableExtensibleSectionData.h>
#import <GLIMUI/GLIMTableExtensibleCellData.h>
#import <GLIMUI/GLIMTableViewExtensionCell.h>


#import <GLIMUI/GLIMGDTRecentChatListBannerViewManager.h>

#import <GLIMUI/GLIMQIYUManager.h>
#import <GLIMUI/GLIMFlutterInterface.h>
#import <GLIMUI/GLIMBellManager.h>

/// 通知数据
#import <GLIMUI/GLIMMessageNotifyData.h>


//Flutter 暂时引用
#import <GLIMUI/GLIMOrderAutoReplyViewController.h>
#import <GLIMUI/GLIMAutoReplySettingsViewController.h>
#import <GLIMUI/GLIMCustomerServiceViewController.h>
#import <GLIMUI/GLIMSystemMessageShowViewController.h>
#import <GLIMUI/GLIMUIConfig+Private.h>
#import <GLIMUI/GLIMAutoReplySettingListVc.h>



#import <GLIMUI/GLIMOffLineMessagePoolChoiceNavView.h>
#import <GLIMUI/GLIMOffLineMessagePoolChoiceView.h>
#import <GLIMUI/GLIMOffLineMessagePoolChoiceViewCell.h>

// 表情相关
#import <GLIMUI/GLIMUIBlockDefine.h>
#import <GLIMUI/GLIMEmojiData.h>
#import <GLIMUI/GLIMEmojiPackageData.h>
#import <GLIMUI/GLIMEmojiManager.h>
#import <GLIMUI/GLIMEmojiPackageManager.h>
#import <GLIMUI/GLIMAnimatedImageView.h>
#import <GLIMUI/UIView+GLIMBadge.h>

// 悬浮视图
#import <GLIMUI/GLIMBaseFloatingView.h>


