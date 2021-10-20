//
//  GLIMMessageBottomProtocol.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/3.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#ifndef GLIMMessageBottomProtocol_h
#define GLIMMessageBottomProtocol_h

typedef NS_ENUM(NSInteger, GLIMMessageBottomMode)
{
    GLIMMessageBottomNone   = 0,        //
    GLIMMessageBottomText   = 1 << 0,   // 文本输入
    GLIMMessageBottomAudio  = 1 << 1,   // 语音输入
    GLIMMessageBottomEmoji  = 1 << 2,   // 表情输入
    GLIMMessageBottomAction = 1 << 3,   // 扩展输入
    
    GLIMMessageBottomAll = GLIMMessageBottomText | GLIMMessageBottomAudio | GLIMMessageBottomEmoji | GLIMMessageBottomAction, 
};

typedef NS_ENUM(NSInteger, GLIMMessageBottomBanType) {
    GLIMMessageBottomBanNone,   //
    GLIMMessageBottomBanAll,    // 全员禁言
    GLIMMessageBottomBanMe,     // 我被禁言
    GLIMMessageBottomGroupLiveAlreadyExpired, // 直播群已满
    GLIMMessageBottomGroupBeNotInGroup, // 不在群聊
    GLIMMessageBottomGroupDissolved,    // 群被解散
    GLIMMessageBottomWeiXinShowTitle //
};

@class GLIMMessage;
@protocol GLIMMessageBottomDelegate <NSObject>

- (void)inputDidFinished:(GLIMMessage *)message;

@optional
#pragma mark - 输入状态相关接口
/// 正在输入文本消息
- (void)didTextInputStart;
/// 结束输入文本消息
- (void)didTextInputEnd;
/// 正在输入语音消息
- (void)didAudioInputStart;
/// 结束输入语音消息
- (void)didAudioInputEnd;

#pragma mark - 录音相关接口
/// 录音接口
- (void)didAudioRecordBegin;
- (void)didAudioRecordEnd;

#pragma mark - @操作
/// 是否支持@符号
- (BOOL)supportAtSomeone;
/// 执行At操作
- (void)excuteAtSomeoneOperation;

@end

@class GLIMMessageBottomView;
@protocol GLIMMessageBottomViewDelegate <GLIMMessageBottomDelegate>

- (void)bottomView:(GLIMMessageBottomView *)bottomView didChangedInputMode:(GLIMMessageBottomMode)inputMode;

@end

#endif /* GLIMMessageBottomProtocol_h */
