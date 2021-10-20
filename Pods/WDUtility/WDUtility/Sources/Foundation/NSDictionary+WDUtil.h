//
//  NSDictionary+WDUtil.h
//  KouDai
//
//  Created by Fnoz on 16/4/20.
//
//

#import <UIKit/UIKit.h>

@interface NSDictionary (WDUtil)

#define WDDictionaryKeyAndObj(...) [NSDictionary wd_dictionaryKeysAndObjects:__VA_ARGS__, nil]

+ (NSDictionary *)wd_dictionaryKeysAndObjects:(NSObject *)obj, ...NS_REQUIRES_NIL_TERMINATION;

- (NSString*)wd_stringObjectForKey:(NSString*)key;
- (NSNumber*)wd_numberObjectForKey:(NSString*)key;

@end
