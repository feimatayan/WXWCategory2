//
//  GLIMRecentExtensibleData.h
//  GLIMUI
//
//  Created by huangbiao on 2018/7/24.
//  Copyright © 2018年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 最近联系人列表扩展功能数据
 */
@interface GLIMRecentExtensibleData : NSObject

/// 显示数据
@property (nonatomic, strong) id cellData;
/// 显示Cell的类名
@property (nonatomic, copy) NSString *cellClassName;
/// 子账号是否支持
@property (nonatomic, assign) BOOL supportSubAccount;

/// 请求扩展数据
- (void)requesetExtensibleData;

/// 如果有数据请求，则在请求完成后调用此方法刷新UI
- (void)refreshExtensibleData;

/// 处理点击事件
- (void)didExtensibleCellClicked;

@end
