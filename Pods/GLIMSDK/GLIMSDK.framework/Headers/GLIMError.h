//
//  GLIMError.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/16.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GLIM_PROTOCOL_ERROR_DOMAIN  @"GLM_PROTOCOL_ERROR"

/// 返回成功
#define GLIM_RESPONSE_SUCCESS                   200000
/// 服务器返回的 PB Response Data 为空
#define GLIM_RESPONSE_PB_DATA_NIL               600001
/// 请求超时
#define GLIM_REQ_TIMEOUT                        600002
/// 网络被断开
#define GLIM_CONN_DISCONNECT                    600003
/// 没有网络连接
#define GLIM_NO_NETWORK                         600004


/**
 *  Client Error
 */
#define     ERROR_LOGIC_CLIENT_LACK_PARAM        400001
#define     ERROR_LOGIC_BAD_REQUEST              400002
#define     ERROR_LOGIC_BAD_TOKEN                400003
#define     ERROR_LOGIC_EXPIRED_TOKEN            400004
#define     ERROR_LOGIC_BAD_USS                  400005
#define     ERROR_LOGIC_MSG_TOO_LONG             400006
#define     ERROR_LOGIC_MSG_SEND_TO_SELF         400007
#define     ERROR_LOGIC_AS_COMMON_CHECK_FAIL     400008
#define     ERROR_LOGIC_QUERY_COUNT_TO_LONG      400009
#define     ERROR_LOGIC_USER_IS_VISITOR          400010
#define     ERROR_LOGIC_USER_MEMO_TOLONG         400011
#define     ERROR_LOGIC_USER_NOT_HAVE_LIMIT      401016

/**
 *  验证码
 */
#define     ERROR_LOGIC_USER_CHECK_CODE          400012
#define     ERROR_LOGIC_USER_WRONG_CODE          400013

/**
 *  Server Error: Common
 */
#define     ERROR_LOGIC_EXCEPTION                510001
#define     ERROR_LOGIC_USER_A_IS_BLOCKED        510002
#define     ERROR_LOGIC_GENERATE_TOKEN_FAIL      510003
#define     ERROR_LOGIC_GENERATE_UID_FAIL        510004
#define     ERROR_LOGIC_SERVER_LACK_PARAM        510005
#define     ERROR_LOGIC_PARSE_JSON_FAIL          510006
#define     ERROR_LOGIC_BAD_PB_RESPONSE          510007
#define     ERROR_LOGIC_SERVER_BAD_RESP          510008
#define     ERROR_LOGIC_COMMON_CHECK_FAIL        510009
#define     ERROR_LOGIC_WRONG_SERVER_RESP_CODE   510010
/**
 *  Server Error: DAS
 */
#define     ERROR_LOGIC_PUT_DAS                  511001
#define     ERROR_LOGIC_DUPLICATE_SID            511002
#define     ERROR_LOGIC_DUPLICATE_UID            511003
#define     ERROR_LOGIC_PARSE_DAS_RESP           511004
#define     ERROR_LOGIC_QUERY_DAS_NO_RESULT      511005
#define     ERROR_LOGIC_DAS_PARSE_RESULT         511006
#define     ERROR_LOGIC_INSERT_DAS_RESP          511007

/**
 * /TIMEOUT
 */
#define     ERROR_LOGIC_DAS_TIMEOUT              512001
#define     ERROR_LOGIC_ROUTER_TIMEOUT           512002
#define     ERROR_LOGIC_SPAM_TIMEOUT             512003
#define     ERROR_LOGIC_TRANSIT_TIMEOUT          512003


/// 错误代码枚举值
typedef NS_ENUM(NSUInteger, GLIMErrorCode){
    GLIMErrorCodeNone           = 0,        // 无错误
    GLIMErrorCodeKickoff        = 518,      // 被踢了
    GLIMErrorCodeTimeout        = 618,      // 操作超时(连接、读写)
    GLIMErrorCodeClosedByServer = 718,      // 被远程关闭
    GLIMErrorCodeManualCancel,              // 手动取消
    GLIMErrorCodeOther          = 10018,    // 其他错误
    
    GLIMErrorCodeLogingIn       = 12000,    // 正在登录
    
    GLIMErrorUnauthority = 1000000,         // 未授权
};

@interface GLIMError : NSObject

+ (instancetype)sharedInstance;

#pragma mark - 
- (void)loadErrorCodeConfiguration;

+ (NSDictionary *)userInfoWithErrorCode:(UInt32)errorCode;
+ (NSError *)socketErrorWithErrorCode:(UInt32)errorCode;

#pragma mark -
/// 通用的错误
+ (NSError *)errorWithCode:(UInt32)errorCode description:(NSString *)description;
+ (NSError *)errorWithDomain:(NSString *)domain code:(UInt32)errorCode description:(NSString *)description;
/// 超时
+ (NSError *)timeoutErrorWithCmd:(id)cmd;
/// 空结果
+ (NSError *)emptyResponseErrorWithCmd:(id)cmd;
/// 网络不可达
+ (NSError *)notReachableError;
/// 参数无效
+ (NSError *)invalidParamError;
/// 空账号
+ (NSError *)emptyAccountError;
/// 连接失败
+ (NSError *)disconnectError;
/// 手动取消
+ (NSError *)manualCancelError;
/// 所有服务都不可用
+ (NSError *)allServerDisconnectError;
/// 未识别的命令
+ (NSError *)unidentifiedCommandError;
/// PB解析出错
+ (NSError *)parsePBModelError;

/// 微店Token失效
+ (NSError *)userTokenIsInvalidError;
/// 未授权错误
+ (NSError *)unauthorizedError;

+ (NSDictionary *)errorInfoWithError:(NSError *)error;

@end

/// 错误数据
@interface GLIMErrorData : NSObject

/// 基本信息-错误域
@property (nonatomic, copy) NSString *domain;
/// 基本信息-错误码
@property (nonatomic, assign) NSInteger code;

/// 扩展信息-错误码
@property (nonatomic, assign) NSInteger statusCode;
/// 扩展信息-错误原因
@property (nonatomic, copy) NSString *statusReason;

/// 构造实例
- (instancetype)initWithCode:(NSInteger)code
                  statusCode:(NSInteger)statusCode
                statusReason:(NSString *)statusReason;

/// 扩展信息
- (NSDictionary *)userInfo;

/// 生成NSError
- (NSError *)error;

/// 构造实例
+ (instancetype)dataWithCode:(NSInteger)code
                  statusCode:(NSInteger)statusCode
                statusReason:(NSString *)statusReason;

/// 由错误信息构造实例
/// @param error 错误信息
+ (instancetype)dataWithError:(NSError *)error;

/// 假数据
+ (instancetype)mockErrorData;

#pragma mark - Bussiness
/// 权限错误
- (BOOL)isUnauthorityError;

@end
