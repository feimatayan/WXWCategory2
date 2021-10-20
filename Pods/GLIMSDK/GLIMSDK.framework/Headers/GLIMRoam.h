//
//  GLIMRoam.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/22.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMBaseObject.h"

/// 漫游锚点
@interface GLIMRoam : GLIMBaseObject

/// 漫游ID（消息的serverMsgID）,考虑到漫游表是message与contact的关联表，为节省字段直接用roamID存储消息的serverMsgID
@property (nonatomic, strong) NSString *roamID;
/// 会话ID（具体会话ID）
@property (nonatomic, strong) NSString *chatID;

@end
