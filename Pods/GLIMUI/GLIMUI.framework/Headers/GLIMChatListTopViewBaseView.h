//
//  GLIMChatListTopViewBaseView.h
//  GLIMUI
//
//  Created by jiakun on 2020/7/31.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import <GLIMUI/GLIMUI.h>

NS_ASSUME_NONNULL_BEGIN

@class GLIMChatListTopViewBaseView;

@protocol GLIMChatListTopViewBaseViewDelegate <NSObject>
@optional

- (void)updateChatListTopViewFrame:(GLIMChatListTopViewBaseView *)view;

@end



@interface GLIMChatListTopViewBaseView : UIView

@property (nonatomic, weak) id <GLIMChatListTopViewBaseViewDelegate> delegate;

+ (BOOL)isSupportCurrentViewWithChat:(GLIMChat *)chat;

+ (instancetype)getChatTopViewWithSuperView:(UIView *)superView chatTitleView:(GLIMChatTitleView *)chatTitleView chat:(GLIMChat *)chat;

- (void)refreshChatTopViewData;

- (void)refreshChatTopViewDataWithDicData:(NSDictionary *)dicData;

- (void)updateFrame;

@end

NS_ASSUME_NONNULL_END
