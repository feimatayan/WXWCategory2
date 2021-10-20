//
// Created by shazhou on 2018/7/10.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTSessionManager.h"
#import "WDUTConfig.h"
#import <UIKit/UIKit.h>

#define WDUTSessionVersion @"4"

@implementation WDUTSessionManager {
    NSString *_appState;

    NSString *_sessionId;

    NSTimeInterval _timeEnterBackground;
}

+ (WDUTSessionManager *)instance {
    static WDUTSessionManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

+ (NSString *)getSessionId {
    return [[WDUTSessionManager instance] getSessionId];
}

- (id)init {
    self = [super init];
    if (self) {

        _appState = @"0";

        _sessionId = [self generateSession];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (NSString *)getSessionId {
    return [_sessionId copy];
}

- (void)appBecomeActive {
    _appState = @"0";
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (_timeEnterBackground > 0 && (now - _timeEnterBackground) > [WDUTConfig instance].sessionRefreshDuration) {
        _sessionId = [self generateSession];
    }
}

- (void)appEnterBackground {
    _timeEnterBackground = [[NSDate date] timeIntervalSince1970];
    _appState = @"1";
}

/*
 * session格式见 http://docs.vdian.net/display/mobile/session
 *
 * */
- (NSString *)generateSession {
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSString *random = [NSString stringWithFormat:@"%06d", arc4random() % 100000];
    return [NSString stringWithFormat:@"ks_%@_%@_%@_%@", WDUTSessionVersion, timestamp, random, _appState];
}

@end
