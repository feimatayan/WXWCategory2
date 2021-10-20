//
//  GLIMChatSourceManager.h
//  GLIMUI
//
//  Created by 六度 on 2017/12/21.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>

@protocol GLIMChatSourceManagerDeleagte <NSObject>

@optional

- (void)didTapChatSourceWithChatSource:(GLIMChatSource *)chatSource;

@end

@interface GLIMChatSourceManager : NSObject
@property (nonatomic,weak) id<GLIMChatSourceManagerDeleagte> delegate;

+ (instancetype)sharedInstance;

@end
