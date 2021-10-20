//
//  GLIMMessageBottomExtendView.h
//  GLIMUI
//
//  Created by huangbiao on 2019/3/21.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GLIMChat;
@class GLIMMessageBottomExtendView;

@protocol GLIMMessageBottomExtendViewDelegate <NSObject>

@optional
/// 视图高度变化
- (void)extendView:(GLIMMessageBottomExtendView *)extendView
  heightDidChanged:(CGFloat)height;

/// 跳转到其他页面时需要对聊天页面进行特殊处理
- (void)closeShortcutViewWhenJumpOtherView;

@end

@class GLIMMessageBottomExtendSubView;
@protocol GLIMMessageBottomExtendSubViewDelegate <NSObject>

@optional
/// 通知父视图重新布局所有子视图
- (void)relayoutAllSubViews;
/// 跳转到其它页面之前需要进行处理，如关闭快捷聊天页面
- (void)doSomethingBeforeJumpOtherView;

@end

@interface GLIMMessageBottomExtendSubView : UIView

/// 代理类
@property (nonatomic, weak) id<GLIMMessageBottomExtendSubViewDelegate> delegate;

/// 返回实际视图
+ (instancetype)extendSubView;

/// 请求扩展数据，如果请求数据后UI有变化，需要调用delegate的relayoutAllSubViews方法进行重新布局
- (void)requestExtendData:(NSString *)groupExtends;

/// 点击事件是跳转页面时，需要调用此方法
- (void)doSomethingBeforeJumpOtherView;

@end

@interface GLIMMessageBottomExtendView : UIView <GLIMMessageBottomExtendSubViewDelegate>

/**
 视图高度
 
 @param viewData 视图显示数据
 @return 视图高度
 */
+ (CGFloat)viewHeightWithData:(nullable id)viewData;

/// 视图相关协议，如高度变化、页面跳转之前的处理逻辑
@property (nonatomic, weak) id<GLIMMessageBottomExtendViewDelegate> delegate;
/// 需要展现的数据，实际业务取决于具体业务
@property (nonatomic, strong) id viewData;
/// 记录聊天页面联系人信息
@property (nonatomic, strong) GLIMChat* chat;

/// 刷新当前视图
- (void)refreshBottomView:(NSString *)groupExtends;

@end

NS_ASSUME_NONNULL_END
