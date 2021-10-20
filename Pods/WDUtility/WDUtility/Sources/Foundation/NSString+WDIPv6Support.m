//
//  NSString+WDIPv6Support.m
//  WDUtility
//
//  Created by shazhou on 16/5/16.
//  Copyright © 2016年 Henson. All rights reserved.
//

#import "NSString+WDIPv6Support.h"
#include <netdb.h>
#include <arpa/inet.h>
#include <resolv.h>
#import "NSString+WDFoundation.h"

@implementation NSString (WDIPv6Support)

+ (nullable NSString *)wd_ipAddress:(NSString *)ipv4String
{
    if (ipv4String == nil || [ipv4String wd_isBlank]) {
        return nil;
    }
    
    struct addrinfo hints, *res, *res0;
    NSString *convertedIpStr = nil;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = PF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_DEFAULT;
    int error = getaddrinfo([ipv4String UTF8String], "http", &hints, &res0);
    if (error) {
        //getaddrinfo error
        return nil;
    }
    
    for (res = res0; res; res = res->ai_next) {
        if (res->ai_addr->sa_family == AF_INET6) {
            char ipstr[INET6_ADDRSTRLEN];
            inet_ntop(AF_INET6,
                      &(((struct sockaddr_in6 *)(res->ai_addr))->sin6_addr),
                      ipstr, sizeof(ipstr));
            convertedIpStr = [[NSString alloc] initWithUTF8String:ipstr];
        } else if (res->ai_addr->sa_family == AF_INET) {
            char ipstr[INET_ADDRSTRLEN];
            inet_ntop(AF_INET,
                      &(((struct sockaddr_in *)(res->ai_addr))->sin_addr),
                      ipstr, sizeof(ipstr));
            convertedIpStr = [[NSString alloc] initWithUTF8String:ipstr];
        }
    }
    
    freeaddrinfo(res0);
    
    return convertedIpStr;
}

+ (nullable NSString *)getDNSAddress {
    NSString *dnsAddr = nil;
    res_state res = malloc(sizeof(struct __res_state));
    int result = res_ninit(res);
    if (result == 0) {
        union res_9_sockaddr_union *addr_union = malloc(res->nscount * sizeof(union res_9_sockaddr_union));
        res_getservers(res, addr_union, res->nscount);
        
        for (int i = 0; i < res->nscount; i++) {
            if (addr_union[i].sin.sin_family == AF_INET) {
                char ip[INET_ADDRSTRLEN];
                inet_ntop(AF_INET, &(addr_union[i].sin.sin_addr), ip, INET_ADDRSTRLEN);
                dnsAddr = [NSString stringWithUTF8String:ip];
            } else if (addr_union[i].sin6.sin6_family == AF_INET6) {
                char ip[INET6_ADDRSTRLEN];
                inet_ntop(AF_INET6, &(addr_union[i].sin6.sin6_addr), ip, INET6_ADDRSTRLEN);
                dnsAddr = [NSString stringWithUTF8String:ip];
            }
        }
    }
    res_nclose(res);
    return dnsAddr;
}

@end
