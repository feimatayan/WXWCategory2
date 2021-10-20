//
//  GLIMMessageBottomView.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/3.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMMessageBottomProtocol.h"

@interface GLIMMessageBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame withChat:(GLIMChat *)chat;

@property (nonatomic, weak) GLIMChat *chat;
@property (nonatomic, weak) id<GLIMMessageBottomViewDelegate> delegate;
@property (nonatomic, assign) CGFloat viewHeight;

#pragma mark - HeadView
/// 配置headView的显示模式
@property (nonatomic, assign) GLIMMessageBottomMode headerViewDisplayMode;

/// 适配高度
+ (CGFloat)adjustHeight;

- (UITextView *)getGrowingTextView;
- (void)resignBottomFirstResponder;
- (BOOL)isBottomFirstResponder;
- (void)headerViewBecomeFirstResponder;
/// 停止所有输入操作
- (void)stopAllInputAction;

- (void)headViewAppendString:(NSString *)string;
- (void)headViewSendString:(NSString *)string;
- (void)clearTextViewAllString;

/**
 输入框删除操作
 如果最后一个是@某人，删除@某人标识
 如果最后一个是表情符号，则删除表情符号
 如果最后一个是普通文本，则删除文本
 */
- (void)headViewSmartDelete;
/// 输入框删除最后一个文本字符串
- (void)headViewSmartDeleteText;

- (void)headViewDidSendMessage:(id<GLIMMessageBottomDelegate>)delegate;

#pragma mark - 禁言相关逻辑
@property (nonatomic, assign, readonly) NSInteger banIntervals;
/**
 根据禁言状态刷新当前视图
 
 @param banType 禁言类型，0 - 无禁言，1 - 全员禁言 2 - 单人禁言
 @param banTime 禁言时长
 */
- (void)refreshViewWithBanType:(GLIMMessageBottomBanType)banType
                       banTime:(NSInteger)banTime;
- (void)refreshViewWithBanType:(GLIMMessageBottomBanType)banType
                      banTitle:(NSString *)title;

#pragma mark - AtSomeone
- (void)addAtSomeoneWithObj:(id)someone;

- (void)addWelcomePersionWithObj:(id)someone;

#pragma mark - ActionView
/// actionView上显示的item列表
@property (nonatomic, strong) NSArray *actionItemDataArray;

/**
 刷新actionView

 @param actionItemDataArray actionView上的数据
 @param forceRefresh 是否强制刷新，YES：强制刷新 or NO：不强制刷新
 */
- (void)showActionViewWithArray:(NSArray *)actionItemDataArray forceRefreshed:(BOOL)forceRefresh;

#pragma mark - 调整UI
- (void)headerViewHideTopLine;

- (CGRect)headerViewRect;

@end
