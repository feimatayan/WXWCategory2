//
//  GLIMChatTopBaseView.h
//  GLIMUI
//
//  Created by jiakun on 2018/9/20.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
#import <GLIMUI/GLIMUI.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GLIMChatTopViewType) {
    GLIMChatTopViewType_None = 0,//默认
    GLIMChatTopViewType_GroupWelfareAndDynamic = 1,//群福利和动态
};

@protocol GLIMChatTopBaseViewDelegate <NSObject>
@optional

/**
 回调数据
 
 @param dic 字典
 */
- (void)chatTopBaseViewDataCallBack:(NSDictionary *)dic;

/**
 销毁时回调
 */
- (void)chatTopBaseViewDestroyChatTopView;

/**
收起聊天页面页面键盘
 */
- (void)chatViewKeyboardHidden;


@end

@interface GLIMChatTopBaseView : UIView

@property (nonatomic, strong) GLIMChat *chat;

@property (nonatomic, assign) BOOL isChatTopViewHidden;

@property (nonatomic, strong) GLIMChatTitleView *chatTitleView;

@property (nonatomic, weak) UIView *mySuperView;

@property (nonatomic, weak) id <GLIMChatTopBaseViewDelegate> delegate;


+ (BOOL)isSupportCurrentViewWithChat:(GLIMChat *)chat;

+ (instancetype)getChatTopViewWithSuperView:(UIView *)superView chatTitleView:(GLIMChatTitleView *)chatTitleView chat:(GLIMChat *)chat;

- (void)refreshChatTopViewData;

- (void)refreshChatTopViewDataWithDicData:(NSDictionary *)dicData;

- (void)hiddenChatTopView;

- (void)showChatTopView;

- (void)destroyChatTopView;

- (void)hidddenNav;

@end

NS_ASSUME_NONNULL_END
