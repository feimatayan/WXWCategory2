//
// Created by 陈岳燊 on 16/8/3.
//

#import "NSString+WDURL.h"
#import "WDUtility.h"

@implementation NSString (WDURL)

- (NSString *)wd_encodeURL {
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

- (NSString *)wd_decodeURL {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)wd_encodeChineseString {
    return (__bridge_transfer NSString *) (CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
            (__bridge CFStringRef) self,
            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
            NULL,
            kCFStringEncodingUTF8));
}

- (NSURL *)wd_addQuery:(NSDictionary *)queryDictionary {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:self];

    if (queryDictionary.count == 0) {
        return urlComponents.URL;
    }

    if (!urlComponents.queryItems) {
        urlComponents.queryItems = @[];
    }
    [queryDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *value;
        if ([obj isKindOfClass:NSNumber.class]) {
            value = [(NSNumber *) obj stringValue];
        } else if ([obj isKindOfClass:NSString.class]) {
            value = obj;
        }
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
        urlComponents.queryItems = [urlComponents.queryItems arrayByAddingObject:item];
    }];
    return urlComponents.URL;
}

+ (NSString *)wd_paramValueOfGetForKey:(NSString *)key ofURL:(NSString *)url {
    if (key.length == 0) {
        return nil;
    }

    NSDictionary *query = [[NSURL URLWithString:url] wd_params];
    return query[key];
}

+ (NSString *)wd_paramDecValueOfGetForKey:(NSString *)key ofURL:(NSString *)url {
    NSString *value = [self wd_paramValueOfGetForKey:key ofURL:url];
    return [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)wd_params {
    return [[[NSURL alloc] initWithString:self] wd_params];
}

+ (NSDictionary *)wd_params:(NSString *)sUrl {
    return [sUrl wd_params];
}

+ (NSArray *)wd_getParamComponentsByUrl:(NSString *)sUrl {
    if (sUrl && [sUrl length] > 0) {
        NSMutableString *strUrl = [[NSMutableString alloc] init];
        [strUrl setString:sUrl];
        NSRange searchRange = NSMakeRange(0, [strUrl length]);
        [strUrl replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:searchRange];

        NSRange r = [strUrl rangeOfString:@"?"];
        if (r.length <= 0) {
            return nil;
        }
        NSString *strParam = [strUrl substringFromIndex:(r.location + r.length)];
        NSArray *arrParam = [strParam componentsSeparatedByString:@"&"];
        return arrParam;
    }
    return nil;
}

+ (NSString *)wd_getParamValue:(NSString *)strKey params:(NSArray *)arrParam {
    if (strKey && [strKey length] > 0) {
        for (NSString *strP in arrParam) {
            NSRange r = [strP rangeOfString:strKey];
            if (r.length > 0) {
                NSString *strKey = [strP substringFromIndex:(r.location + r.length)];
                NSRange rKey = [strKey rangeOfString:@"="];
                if (rKey.length > 0) {
                    NSString *strV = [strKey substringFromIndex:(rKey.location + rKey.length)];
                    return [strV stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
            }
        }
    }
    return @"";
}

@end
