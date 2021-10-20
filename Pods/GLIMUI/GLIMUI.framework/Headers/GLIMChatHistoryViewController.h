//
//  GLIMChatHistoryViewController.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/22.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMChatBaseViewController.h"

@interface GLIMChatHistoryViewController : GLIMChatBaseViewController
//起始消息id
@property (nonatomic,strong)NSString * msgID;
//是否从营销联系人进入 默认 NO
@property (nonatomic,assign ) BOOL isMarketing;

/// 是否支持跳转小程序聊天历史
@property (nonatomic, assign) BOOL supportJumpWxProc;

@end
