//
// Created by shazhou on 2018/7/11.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTKeychainWrapper.h"

@implementation WDUTKeychainWrapper

+ (NSMutableDictionary *)getPrivateKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id) (kSecClassGenericPassword), kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            (__bridge id) kCFBooleanFalse, (__bridge id) kSecAttrSynchronizable,
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, kSecAttrAccessible, nil];
}

+ (NSMutableDictionary *)getSharedKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id) (kSecClassGenericPassword), kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            (__bridge id) kCFBooleanFalse, (__bridge id) kSecAttrSynchronizable,
            kSecAttrAccessibleAfterFirstUnlock, kSecAttrAccessible, nil];
}

+ (void)savePrivateData:(id <NSCoding>)privateData forKey:(NSString *)key {
    NSMutableDictionary *query = [self getPrivateKeychainQuery:key];
    [self saveData:privateData forQuery:query];
}

+ (void)saveSharedData:(id <NSCoding>)sharedData forKey:(NSString *)key {
    NSMutableDictionary *query = [self getSharedKeychainQuery:key];
    [self saveData:sharedData forQuery:query];
}

+ (void)saveData:(id)data forQuery:(NSMutableDictionary *)query {
    SecItemDelete((__bridge CFDictionaryRef) (query));
    [query setObject:[NSKeyedArchiver archivedDataWithRootObject:data]
              forKey:(__bridge id <NSCopying>) (kSecValueData)];
    SecItemAdd((__bridge CFDictionaryRef) (query), NULL);
}

+ (id)loadPrivateDataForKey:(NSString *)key {
    return [self loadObjectForQuery:[self getPrivateKeychainQuery:key]];
}

+ (id)loadSharedDataForKey:(NSString *)key {
    return [self loadObjectForQuery:[self getSharedKeychainQuery:key]];
}

+ (id)loadObjectForQuery:(NSMutableDictionary *)keychainQuery {
    id ret = nil;
    [keychainQuery setObject:(id) kCFBooleanTrue forKey:(__bridge id <NSCopying>) (kSecReturnData)];
    [keychainQuery setObject:(__bridge id) (kSecMatchLimitOne) forKey:(__bridge id <NSCopying>) (kSecMatchLimit)];

    CFTypeRef result = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef) keychainQuery, &result) == noErr) {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *) result];
    }
    if (result) {
        CFRelease(result);
    }
    return ret;
}

+ (void)deletePrivateDataForKey:(NSString *)service {
    NSMutableDictionary *query = [self getPrivateKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef) (query));
}

+ (void)deleteSharedDataForKey:(NSString *)service {
    NSMutableDictionary *query = [self getSharedKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef) (query));
}

@end