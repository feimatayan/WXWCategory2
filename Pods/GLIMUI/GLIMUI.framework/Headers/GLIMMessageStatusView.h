//
//  GLIMMessageStatusView.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>

typedef NS_ENUM(NSUInteger, GLMMessageStatusViewType)
{
    GLMMessageStatusViewTypeSuccess = 10,
    GLMMessageStatusViewTypeSending = 11,
    GLMMessageStatusViewTypeFailed = 12
};
@protocol GLMMessageStatusViewDelegate;

@interface GLIMMessageStatusView : UIView
@property (nonatomic, weak) id <GLMMessageStatusViewDelegate> delegate;
@property (nonatomic, readonly, assign) GLMMessageStatusViewType statusViewType;
@property (nonatomic, strong) GLIMMessage * message;

- (void)resetStatus;

- (void)reloadStatus:(GLMMessageStatusViewType)type;

@end

@protocol GLMMessageStatusViewDelegate <NSObject>

- (void)didTapResendButtonInStatusView:(GLIMMessageStatusView *)statusView;

@end
