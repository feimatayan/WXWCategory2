//
// Created by 石恒智 on 2018/4/13.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WDHTTPCookieStorageType) {
    WDHTTPCookieStorageTypeNSHTTPCookieStore,
    WDHTTPCookieStorageTypeWKHTTPCookieStore,
};

@interface WDHTTPCookieStorage : NSObject

+ (instancetype)defaultCookieStorage;

/*! @abstract Fetches all stored cookies.默认从NSHTTPCookieStorage中获取
 @param completionHandler A block to invoke with the fetched cookies.
 */
- (void)getAllCookies:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler;

/*! @abstract Fetches all stored cookies.
 @param cookieStoreType cookie数据源的类型.
 @param completionHandler A block to invoke with the fetched cookies.
 */
- (void)getAllCookiesByType:(WDHTTPCookieStorageType)cookieStoreType
            completionBlock:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler;

/*! @abstract Set a cookie.
 @param cookie The cookie to set.
 @param completionHandler A block to invoke once the cookie has been stored.
 */
- (void)setCookie:(NSHTTPCookie *)cookie
completionHandler:(nullable void (^)(BOOL isSuccess))completionHandler;

/*! @abstract Delete the specified cookie.
 @param completionHandler A block to invoke once the cookie has been deleted.
 */
- (void)deleteCookie:(NSHTTPCookie *)cookie
   completionHandler:(nullable void (^)(BOOL isSuccess))completionHandler;


/*! @abstract Clear all cookies from NSHTTPCookieStorage and WKHTTPCookirStore
 @param completionHandler A block to invoke once the cookie has been cleared.
 */
- (void)clearAllCookie:(nullable void (^)(void))completionHandler;


/// Return jsCookire String
/// @param cookies target Cookies
+ (NSString *)jsCookieStringForCookies:(NSArray<NSHTTPCookie *> *) cookies;

@end
