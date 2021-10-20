//
//  WDIMShareChatViewController.h
//  WDIMExtension
//
//  Created by 六度 on 2017/6/27.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMBaseViewController.h"

typedef NS_ENUM(NSInteger, GLIMShareActionType) {
    GLIMShareActionCancel,          // 取消分享
    GLIMShareActionSendSucceed,     // 发送分享成功
    GLIMShareActionSendFailed,      // 发送分享失败
};

@interface GLIMShareChatViewController  : GLIMBaseViewController

/// 分享参数
@property (nonatomic, strong) NSDictionary *shareDic;

/// 是否是临时消息
@property (nonatomic, assign) BOOL isTemChat;

/// 分享支持的联系人类型
@property (nonatomic, assign) GLIMChatType supportChatType;

/// 待分享群列表的类型，空：返回所有群，具体类型见GLIMGroupType
@property (nonatomic, strong) NSArray *groupTypeArray;
/// 当前用户处于群的身份，空：表示不限身份，具体成员身份见GLIMGroupMemberIdentityType，0 普通成功，1 群主， 2 群管理员
@property (nonatomic, strong) NSArray *groupIdentifyArray;

/// 是否使用默认Toast
@property (nonatomic, assign) BOOL usingDefaultToast;

/// 关掉页面的回调 微店实现关闭分享页面操作
@property (nonatomic, copy) void (^closePage)(GLIMShareChatViewController * obj, GLIMShareActionType actionType);

@end
