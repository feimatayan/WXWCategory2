//
// Created by shazhou on 2018/7/18.
// Copyright (c) 2018 Weidian. All rights reserved.
//

#import "WDUTBuilder.h"
#import "WDUT.h"
#import "WDUTEventDefine.h"

@implementation WDUTBuilder {
    WDUTCommitter *_committer;
}

- (id)init {
    self = [super init];
    if (self) {
        _committer = [WDUTCommitter new];
        _committer.reportStrategy = WDUTReportStrategyBatch;

    }
    return self;
}

- (WDUTBuilder *)click {
    _committer.eventId = WDUT_EVENT_TYPE_CLICK;
    return self;
}

- (WDUTBuilder *)exposure {
    _committer.eventId = WDUT_EVENT_TYPE_ITEM_EXPOSURE;
    return self;
}

- (WDUTBuilder *)pushOpen {
    _committer.eventId = WDUT_EVENT_TYPE_PUSH_OPEN;
    return self;
}

- (WDUTBuilder *)pushToken {
    _committer.eventId = WDUT_EVENT_TYPE_PUSH_TOKEN;
    return self;
}

- (WDUTBuilder *)pushArrive {
    _committer.eventId = WDUT_EVENT_TYPE_PUSH_ARRIVE;
    return self;
}

- (WDUTBuilder *)pushDisplay {
    _committer.eventId = WDUT_EVENT_TYPE_PUSH_DISPLAY;
    return self;
}

- (WDUTBuilder *(^)(NSString *eventId))eventId {
    return ^id(NSString *eventId) {
        _committer.eventId = eventId;
        return self;
    };
}

- (WDUTBuilder *(^)(NSString *page))page {
    return ^id(NSString *page) {
        _committer.pageName = page;
        return self;
    };
}

- (WDUTBuilder *(^)(NSString *arg1))arg1 {
    return ^id(NSString *arg1) {
        _committer.arg1 = arg1;
        return self;
    };
}

- (WDUTBuilder *(^)(NSString *controlName))controlName {
    return ^id(NSString *controlName) {
        _committer.arg1 = controlName;
        return self;
    };
}

- (WDUTBuilder *(^)(NSString *arg2))arg2 {
    return ^id(NSString *arg2) {
        _committer.arg2 = arg2;
        return self;
    };
}

- (WDUTBuilder *(^)(NSString *arg3))arg3 {
    return ^id(NSString *arg3) {
        _committer.arg3 = arg3;
        return self;
    };
}

- (WDUTBuilder *(^)(NSDictionary *args))args {
    return ^id(NSDictionary *args) {
        _committer.args = args;
        return self;
    };
}

- (WDUTBuilder *(^)(NSString *module))module {
    return ^id(NSString *module){
        _committer.module = module;
        return self;
    };
}

- (WDUTBuilder *(^)(BOOL isSuccess))isSuccess {
    return ^id(BOOL isSuccess) {
        _committer.success = isSuccess;
        return self;
    };
}

- (WDUTBuilder *(^)(WDUTReportStrategy policy))policy {
    return ^id(WDUTReportStrategy policy) {
        _committer.reportStrategy = policy;
        return self;
    };
}

- (void (^)())commit {
    return ^() {
        [_committer commit];
    };
}

@end

@implementation WDUTCommitter

- (void)commit {
    [WDUT commitEvent:self.eventId pageName:self.pageName arg1:self.arg1 arg2:self.arg2 arg3:self.arg3 args:self.args module:self.module isSuccess:self.success policy:self.reportStrategy];
}

@end
