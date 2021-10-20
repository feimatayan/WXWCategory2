//
//  GLIMMessageTapInfo.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/6.
//  Copyright © 2017年 Koudai. All rights reserved.
//


#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GLIMMessageTapObject) {
    GLIMMessageTapObjectCell = 1,           // 点击了cell
    GLIMMessageTapObjectAutor = 2,          // 点击了头像
    GLIMMessageTapObjectPhoto = 3,          // 图片
    GLIMMessageTapObjectSound = 4,          // 语音
    GLIMMessageTapObjectTextLink = 5,       // 文本链接
    GLIMMessageTapObjectVideo = 6,          // 视频
    GLIMMessageTapObjectFile = 7,           // 文件
    GLIMMessageTapObjectBlockNotify = 201,  // 屏蔽通知
    GLIMMessageTapObjectAutoReply = 202,    // 自动回复
    GLIMMessageTapObjectSystemLink = 301,       // 点击系统消息中的链接
    GLIMMessageTapObjectSystemDiscount = 401,   // 点击系统消息中的优惠券发送
    GLIMMessageTapObjectSystemWelcome = 501,   //欢迎语点击
    GLIMMessageTapObjectSend = 999,             // 发送消息
    GLIMMessageTapObjectReSend = 1000,          // 重发
    GLIMMessageTapObjectWithdraw = 10001,       //撤回操作
    GLIMMessageTapObjectReEdit = 10002,       //重新编辑
    GLIMMessageTapObjectSoundSpeakerAndReceiverPlay = 10003,//切换设备
    GLIMMessageTapObjectSoundSoundContinuityPlay = 10004,//连续播放
    GLIMMessageTapObjectMessageDelete = 10005, //消息删除
    GLIMMessageTapObjectMessageEmojCustomExpression = 10006, //消息删除
    GLIMMessageTapObjectMessageGroupEssence = 10007, //消息精华
    GLIMMessageTapObjectHiddenKeyboard = 10000, // 收起键盘
};
typedef NS_ENUM(NSInteger, GLIMMessageTapGesture) {
    GLIMMessageTapGestureSingle = 1,        // 单击
    GLIMMessageTapGestureLongPress = 2,     // 长按
};

@interface GLIMMessageTapInfo : NSObject
//点击了谁
@property (nonatomic,assign) GLIMMessageTapObject tapObj;
//点击事件
@property (nonatomic,assign) GLIMMessageTapGesture tapGesture;
//自定义
@property (nonatomic,strong) NSDictionary * extraInfo;
@end
