//
//  GLIMSDK.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/10.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GLIMSDK.
FOUNDATION_EXPORT double GLIMSDKVersionNumber;

//! Project version string for GLIMSDK.
FOUNDATION_EXPORT const unsigned char GLIMSDKVersionString[];

#import <GLIMSDK/GLIMSingleton.h>
#import <GLIMSDK/GLIMSDKUtil.h>
#import <GLIMSDK/NSDictionary+Safe.h>
#import <GLIMSDK/NSString+GLIMSDK.h>
#import <GLIMSDK/GLIMFoundationConfig.h>
#import <GLIMSDK/GLIMSDKCustomizingFacade.h>
#import <GLIMSDK/GLIMMessageContentParser.h>

#import <GLIMSDK/GLIMChat.h>
#import <GLIMSDK/GLIMRoam.h>
#import <GLIMSDK/GLIMChatSource.h>
#import <GLIMSDK/GLIMContact.h>
#import <GLIMSDK/GLIMUser.h>
#import <GLIMSDK/GLIMBaseObject.h>
#import <GLIMSDK/GLIMLoginAccount.h>
#import <GLIMSDK/GLIMMessage.h>
#import <GLIMSDK/GLIMMessageTimestamp.h>
#import <GLIMSDK/GLIMMessageBlockNotify.h>
#import <GLIMSDK/GLIMMessageContent.h>
#import <GLIMSDK/GLIMTextContent.h>
#import <GLIMSDK/GLIMSoundContent.h>
#import <GLIMSDK/GLIMImageContent.h>
#import <GLIMSDK/GLIMVideoContent.h>
#import <GLIMSDK/GLIMFileMessageContent.h>
#import <GLIMSDK/GLIMBigEmojiContent.h>
#import <GLIMSDK/GLIMCustomizedContent.h>
#import <GLIMSDK/GLIMSystemMessageContent.h>
#import <GLIMSDK/GLIMPBContext.h>
#import <GLIMSDK/GLIMDataConverter.h>
#import <GLIMSDK/GLIMGroup.h>
#import <GLIMSDK/GLIMGroupMember.h>

#import <GLIMSDK/GLIMCacheManager.h>
#import <GLIMSDK/GLIMConfigManager.h>

#import <GLIMSDK/GLIMAccountManager.h>
#import <GLIMSDK/GLIMChatManager.h>
#import <GLIMSDK/GLIMMessageManager.h>
#import <GLIMSDK/GLIMUserManager.h>
#import <GLIMSDK/GLIMGroupManager.h>
#import <GLIMSDK/GLIMGroupMemberManager.h>
#import <GLIMSDK/GLIMGroupMessageManager.h>
#import <GLIMSDK/GLIMConfigManager.h>
#import <GLIMSDK/GLIMPathManager.h>
#import <GLIMSDK/GLIMFileUploaderManager.h>
#import <GLIMSDK/GLIMFileDownloader.h>
#import <GLIMSDK/GLIMFilterContactsManager.h>

#import <GLIMSDK/GLIMDBManager.h>
#import <GLIMSDK/GLIMDatabasePool.h>
#import <GLIMSDK/GLIMDatabaseQueue.h>

#import <GLIMSDK/GLIMDataKeeper.h>
#import <GLIMSDK/GLIMChatsKeeper.h>
#import <GLIMSDK/GLIMTemChatsKeeper.h>
#import <GLIMSDK/GLIMMessageKeeper.h>
#import <GLIMSDK/GLIMSubAccountChatsKeeper.h>
#import <GLIMSDK/GLIMAllSubAccountChatsKeeper.h>
#import <GLIMSDK/GLIMWxOfficialAccountKeeper.h>
#import <GLIMSDK/GLIMWxProgramChatsKeeper.h>
#import <GLIMSDK/GLIMOffLineMessagePoolChatKeeper.h>

#import <GLIMSDK/GLIMHttpRequest.h>
#import <GLIMSDK/GLIMSocketServerInfo.h>
#import <GLIMSDK/GLIMSocketServerManager.h>

#import <GLIMSDK/GLIMStatisticalManager.h>
#import <GLIMSDK/GLIMMessageInputStatusManager.h>

#import <GLIMSDK/GLIMSearchManager.h>
#import <GLIMSDK/GLIMSDKExtensionUtils.h>
#import <GLIMSDK/GLIMSDKInterface.h>

#import <GLIMSDK/GLIMError.h>

#import <GLIMSDK/GLIMDataCache.h>
/// 快捷回复
#import <GLIMSDK/GLIMQuickReplyData.h>
#import <GLIMSDK/GLIMQuickReplyRequest.h>
/// 自动回复
#import <GLIMSDK/GLIMAutoReplyData.h>
#import <GLIMSDK/GLIMOrderAutoReplyData.h>
#import <GLIMSDK/GLIMAutoReplyManager.h>
#import <GLIMSDK/GLIMAutoReplyNewRequests.h>
/// 子账号
#import <GLIMSDK/GLIMCustomerManager.h>
#import <GLIMSDK/GLIMCustomerServiceData.h>
/// 业务数据扩展
#import <GLIMSDK/GLIMExtensionEntity.h>
#import <GLIMSDK/GLIMCardEntity.h>
//分流设置
#import <GLIMSDK/GLIMCustomerShuntManager.h>
#import <GLIMSDK/GLIMSystemMessageShowManager.h>

/// 场景模拟(Debug)
#import <GLIMSDK/GLIMSituationSimulation.h>

#import <GLIMSDK/GLIMChatLocalClockUtils.h>
#import <GLIMSDK/GLIMNetworkStatusManager.h>

/// 微信
#import <GLIMSDK/GLIMWeiXinManager.h>
/// 离线消息池
#import <GLIMSDK/GLIMOfflineMessagePoolManager.h>



