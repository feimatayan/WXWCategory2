//
//  GLIMQuickReplyData.h
//  GLIMSDK
//
//  Created by 六度 on 2017/2/15.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMQuickReplyData : NSObject

@property (nonatomic, weak) GLIMQuickReplyData *caegory;


//group
@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSString *gmtUpdate;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupNum;

//msg
@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, strong) NSNumber *orderNum;

//内容
@property (nonatomic, copy) NSString *messageContent;

//other
@property (nonatomic, copy) NSString * isDefault; // 1 默认，2 非默认
@property (nonatomic, copy) NSString * uID;
@property (nonatomic, assign) BOOL select;
@property (nonatomic, assign) BOOL isSearchResutl;
@property (nonatomic, assign) BOOL isRecent;
@property (nonatomic, assign) NSRange searchRange;
@property (nonatomic, strong) NSMutableArray *replyDatalist;

@end
