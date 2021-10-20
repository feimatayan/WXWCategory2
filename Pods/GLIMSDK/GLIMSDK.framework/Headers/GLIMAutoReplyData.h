//
//  GLIMAutoReplyData.h
//  WDIMExtension
//
//  Created by 六度 on 2017/7/18.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface GLIMAutoReplyDataPictures : NSObject

@property (nonatomic,strong) NSString * url;

@property (nonatomic,strong) NSString * status;

@property (nonatomic,strong) NSString * picId;

- (void)parseDataFromDictionary:(NSDictionary *)dataDict;

- (NSDictionary *)toDictionary;

@end




@interface GLIMAutoReplyData : NSObject

//问题序列 客户端不关心
@property (nonatomic,strong) NSString * msgNum;
//消息类型 文本1 目前都为1
@property (nonatomic,strong) NSString * msgType;
//问题
@property (nonatomic,strong) NSString * question;
//答案
@property (nonatomic,strong) NSString * answer;
//问题是否启用 1开启 0关闭
@property (nonatomic,strong) NSString * qaStatus;

@property (nonatomic,strong) NSArray * pictures;

- (BOOL)isCanpictureErr;

+ (instancetype)dataFromDictionary:(NSDictionary *)dataDict;

/// 数据转换
- (void)parseDataFromDictionary:(NSDictionary *)dataDict;
- (NSDictionary *)toDictionary;
/// 问题是否启用
- (BOOL)questionEnabled;
/// 问题信息
- (NSDictionary *)questionInfos;

@end

