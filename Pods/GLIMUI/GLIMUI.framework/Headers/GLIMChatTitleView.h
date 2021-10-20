//
//  GLIMChatTitleView.h
//  Pods
//
//  Created by huangbiao on 2017/4/5.
//
//

#import <UIKit/UIKit.h>

@class GLIMContact;

@protocol GLIMChatTitleViewDelegate <NSObject>

@optional

- (void)chatTitleViewClickAction;

@end



/**
 聊天页面标题视图
 */
@interface GLIMChatTitleView : UIView


@property (nonatomic, weak) id <GLIMChatTitleViewDelegate> delegate;

/// 联系人
@property (nonatomic, strong) GLIMContact *contact;

@property (nonatomic, strong) NSString * noticeString;

// 有值会优先显示 nil 需外部修改  此值为nil会显示 noticeString
@property (nonatomic, strong) NSString * inputtingString;

/// 重置输入状态，用于停止计时器
- (void)resetInputStatus;

//底部视图扩展bottomView
// 大小位置限制
//CGRectMake(0, 0, self.chatTitleView.frame.size.width, 13)
- (void)addBottomView:(UIView *)bottomView;
- (void)showBottomView;
- (void)hideenBottomView;
- (void)updateChatTitleFrame:(CGRect)frame;
- (void)addOtherView:(UIView *)view;
@end

/**
 快捷消息里的标题
 */
@interface GLIMShortcutChatTitleView : GLIMChatTitleView

@end
