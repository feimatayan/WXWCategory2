//
//  GLIMQuickReplyRequest.h
//  GLIMSDKLib
//
//  Created by 六度 on 2016/11/14.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "GLIMHttpRequest.h"
#import "GLIMQuickReplyData.h"
/**
 *  @author huangbiao, 15-11-04 15:11:32
 *
 *  快捷消息请求
 *  获取快捷消息列表
 */

@interface GLIMQuickReplyRequest : GLIMHttpRequest

@property (nonatomic, copy) NSString *sID;
@property (nonatomic, copy) NSString *uss;
@property (nonatomic, copy) NSString *uID;
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *messageContent;
@property (nonatomic, strong) NSMutableArray *arrOrderNum;


/**
 *  @author huangbiao, 15-11-04 15:11:48
 *
 *  添加快捷消息
 *  messageContent 快捷消息内容
 */
@end
@interface GLIMQuickReplyAddRequest : GLIMQuickReplyRequest


@end

/**
 *  @author huangbiao, 15-11-04 15:11:06
 *
 *  更新快捷消息
 *  replyID      快捷消息ID
 *  replyContent 快捷消息内容
 */
@interface GLIMQuickReplyUpdateRequest : GLIMQuickReplyRequest


@end

/**
 *  @author huangbiao, 15-11-04 15:11:59
 *
 *  删除快捷消息
 *  replyID 快捷消息ID
 */
@interface GLIMQuickReplyDeleteRequest : GLIMQuickReplyRequest



@end

/**
 *  @author ZhuYan, 16-11-23
 *
 *  设置快捷消息排序
 *  arrReply 快捷消息集合
 */
@interface GLIMQuickReplyUpdateOrderNumRequest : GLIMQuickReplyRequest

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////消息///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////消息///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////消息///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////消息///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//获取最近使用快捷消息
@interface GLIMQuickReplyRecentListRequest : GLIMHttpRequest
@end

//添加快捷消息
@interface GLIMQuickReplyAddMsgRequest : GLIMHttpRequest
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *groupNum;
@property (nonatomic, copy) NSString *groupType;
@end

//更新快捷回复消息
@interface GLIMQuickReplyUpdateMsgRequest : GLIMHttpRequest
@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *groupNum;
@property (nonatomic, copy) NSString *groupType;
@end

//删除快捷回复消息
@interface GLIMQuickReplyDeleteMsgRequest : GLIMHttpRequest
@property (nonatomic, strong) NSMutableArray *msgIdList;
@property (nonatomic, copy) NSString *groupType;
@end

//更新快捷消息顺序
@interface GLIMQuickReplyMsgUpdateOrderNumRequest : GLIMQuickReplyRequest
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, copy) NSString *groupType;
@end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////组/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////组/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////组/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////组/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//快捷消息上报
@interface GLIMQuickReplyGroupMsgReportRequest : GLIMHttpRequest
@property (nonatomic, copy) NSString *msgData;
@property (nonatomic, copy) NSString *msgNum;
@end

//拉取列表接口
@interface GLIMQuickReplyGroupListRequest : GLIMHttpRequest
@property (nonatomic, copy) NSString *groupType;
@end

//添加分组
@interface GLIMQuickReplyAddGroupRequest : GLIMHttpRequest
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupType;
@end

//更新分组
@interface GLIMQuickReplyUpdateGroupRequest : GLIMHttpRequest
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupType;
@end

//删除分组
@interface GLIMQuickReplyDeleteGroupRequest : GLIMHttpRequest
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *isMoveDefault;
@property (nonatomic, copy) NSString *groupType;
@end

//更新快捷组消息顺序
@interface GLIMQuickReplyGroupUpdateOrderNumRequest : GLIMQuickReplyRequest
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, copy) NSString *destGroupType;
@end
