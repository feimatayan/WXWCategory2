//
//  GLIMMessageCellFactory.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>
#import "GLIMMessageCell.h"
@class GLIMMessageUIConfig;

/*
 cell初始化工厂
 根据GLIMMessageUIConfig 吧GLIMMessage和cell关联起来 
 初始化cell
 */
@interface GLIMMessageCellFactory : NSObject

@property (nonatomic,strong)NSMutableArray * messageCellConfig;

+ (GLIMMessageCellFactory *)shareFactory;
//注入新的UIConfig
- (void)addConfig:(GLIMMessageUIConfig *)config;
//根据message生成新的cell
- (GLIMMessageCell *)newCellForMessage:(GLIMMessage *)message;
- (GLIMMessageUIConfig *)configForMessage:(GLIMMessage *)message;

- (void)reset;
@end
