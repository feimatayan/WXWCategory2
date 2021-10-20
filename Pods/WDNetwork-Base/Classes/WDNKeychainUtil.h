//
//  WDNKeychainUtil.h
//  Pods
//
//  Created by yangxin02 on 15/10/29.
//

#import <UIKit/UIKit.h>

/**
 *  github找的一个钥匙串的工具类
 *  https://gist.github.com/Zyphrax/3376201
 *  防止和原来的冲突，这里把类名改了
 */
@interface WDNKeychainUtil : NSObject

// Designated initializer.
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *)accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;
@end