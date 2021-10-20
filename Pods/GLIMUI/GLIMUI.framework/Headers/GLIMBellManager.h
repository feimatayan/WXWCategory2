//
//  GLIMBellManager.h
//  GLIMSDK
//
//  Created by jiakun on 2020/5/25.
//  Copyright © 2020 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIMBellManager : NSObject
+ (instancetype)shareConfig;
- (void)loadConfig;
- (NSDictionary *)configDic;
-(NSString *)getSetCodeWithChatType:(NSString *)chatType type:(NSString *)type;
- (void)setBellConfigWithChatType:(NSString *)chatType bell_type:(NSString *)bell_type shake_type:(NSString *)shake_type withCompletion:(void (^)(NSObject *dic))completion;
@end


@interface GLIMGetBellCommonConfigRequest : GLIMHttpRequest

@end


@interface GLIMSetBellCommonConfigRequest : GLIMHttpRequest
@property (nonatomic, strong) NSString *chatType;
@property (nonatomic, strong) NSString *bell_type;
@property (nonatomic, strong) NSString *shake_type;
@end


NS_ASSUME_NONNULL_END
