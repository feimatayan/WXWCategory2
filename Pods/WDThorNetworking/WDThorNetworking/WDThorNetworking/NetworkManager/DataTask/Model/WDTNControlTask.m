//
//  WDTNControlTask.m
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import "WDTNControlTask.h"

@interface WDTNControlTask ()
@property (nonatomic, weak) id<WDTNControlDelegate> delegate;
@end

@implementation WDTNControlTask

- (instancetype)initWithControlID:(NSString *)controlID taskIdentifier:(NSString *)taskIdentifier delegate:(id<WDTNControlDelegate>)delegate {
    if (self = [super init]) {
        _controlID = controlID;
        _taskIdentifier = taskIdentifier;
        self.delegate = delegate;
    }
    return self;
}

- (void)cancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(canelTask:)]) {
        [self.delegate canelTask:self];
    }
}

@end
