//
//  GLIMEmojiData.h
//  GLIMUI
//
//  Created by huangbiao on 2017/3/4.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMEmojiData : NSObject

/// 表情名称
@property (nonatomic, strong) NSString *emojiName;
/// 表情Image名称
@property (nonatomic, strong) NSString *emojiImageName;

#pragma mark - 大表情使用
/// 表情Image链接
@property (nonatomic, strong) NSString *emojiUrl;

@property (nonatomic, strong) NSString *emojiGifUrl;
@property (nonatomic, strong) NSString *emojiImageGifName;




@property (nonatomic, strong) NSString *key;;


/// 表情文件名
- (NSString *)emojiFileName;


//自定义表情 扩展新加入
//1代表是+ 0正常
@property (nonatomic, assign) NSInteger ce_type;
@property (nonatomic, assign) BOOL ce_selected;
@property (nonatomic, strong) NSString *ce_gmtUpdate;
@property (nonatomic, strong) NSString *ce_uid;
@property (nonatomic, strong) NSString *ce_faceId;

//        "faceFlag":1, // 0 正常 1风控 2删除
@property (nonatomic, strong) NSString *ce_faceFlag;

@property (nonatomic, strong) NSString *ce_groupType;
@property (nonatomic, strong) NSString *ce_faceUrl;

//  "faceType":1 // 1普通表情  2动态表情
@property (nonatomic, strong) NSString *ce_faceType;

- (NSDictionary *)ce_dictionary;
- (void)ce_parseDataWith:(NSDictionary *)dic;

@end
