//
//  GLIMAutoReplyNewRequests.h
//  GLIMSDK
//
//  Created by huangbiao on 2019/9/9.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import <GLIMSDK/GLIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自动回复——新版本获取自动回复信息接口
 包括：自动回复开关、欢迎语、问题列表+推荐商品提示语和推荐商品列表
 */
@interface GLIMAutoReplyGetInfoRequest: GLIMHttpRequest

#pragma mark - 参数

#pragma mark - 结果
@property (nonatomic, strong) NSString *uid;
/// 自动回复开关，1-打开，0-关闭
@property (nonatomic, assign) NSInteger allowReply;
/// 欢迎语信息
@property (nonatomic, copy) NSString *welcomeMessage;
/// 问题列表
@property (nonatomic, strong) NSArray *replyQAList;
/// 推荐商品提示语
@property (nonatomic, copy) NSString *recommandItemPrompt;
/// 推荐商品列表
@property (nonatomic, strong) NSArray *recommendItemArray;

@end

/**
 自动回复——新版本设置提示语接口
 支持设置自动回复欢迎语+推荐商品提示语
 */
@interface GLIMAutoReplySetPromptRequest : GLIMHttpRequest

/// 提示语类型：1-欢迎语 2-商品推荐语
@property (nonatomic, assign) NSInteger promptType;
/// 提示语内容
@property (nonatomic, copy) NSString *promptContent;

@end

/**
 自动回复——新版本设置问题列表接口
 支持单独设置问题列表
 */
@interface GLIMAutoReplySetQAListRequest : GLIMHttpRequest

/// 问题列表
@property (nonatomic, strong) NSArray *replyQAList;

@end

extern const NSString *kGLIMAutoReplyItemIDKey;
extern const NSString *kGLIMAutoReplyItemNameKey;
extern const NSString *kGLIMAutoReplyItemJumpUrlKey;
extern const NSString *kGLIMAutoReplyItemImageUrlKey;
extern const NSString *kGLIMAutoReplyItemStatusKey;
extern const NSString *kGLIMAutoReplyItemPriceKey;

@interface GLIMAutoReplySetRecommandItemListRequest : GLIMHttpRequest

/// 操作类型 1-添加 2-删除
@property (nonatomic, assign) NSInteger opType;
/// 商品id
@property (nonatomic, copy) NSString *itemID;

@end




@interface GLIMriskCheckSetQuestionRequest : GLIMHttpRequest

/// 问题列表
@property (nonatomic, strong) NSDictionary *autoReplyInfo;


@end



NS_ASSUME_NONNULL_END
