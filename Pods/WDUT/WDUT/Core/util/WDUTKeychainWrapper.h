//
// Created by shazhou on 2018/7/11.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDUTKeychainWrapper : NSObject

+ (void)savePrivateData:(id<NSCoding>)privateData forKey:(NSString *)key;
+ (void)saveSharedData:(id<NSCoding>)sharedData forKey:(NSString *)key;

+ (id)loadPrivateDataForKey:(NSString *)key;
+ (id)loadSharedDataForKey:(NSString *)key;

+ (void)deletePrivateDataForKey:(NSString *)service;
+ (void)deleteSharedDataForKey:(NSString *)key;

@end