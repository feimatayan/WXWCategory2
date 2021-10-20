//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import "UIView+WDBlocksKit.h"
#import <objc/runtime.h>


static const void *kWDTouchEndedViewBlockKey = &kWDTouchEndedViewBlockKey;

@implementation UIView (WDBlocksKit)

- (void)wd_whenTapped:(void (^)(void))block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(touchEndedGesture)];
    tapped.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapped];
    objc_setAssociatedObject(self, kWDTouchEndedViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)wd_touchEndedBlock:(void (^)(UIView *selfView))block {
    __weak UIView *weakSelf = self;
    [self wd_whenTapped:^{
        if (block) {
            block(weakSelf);
        }
    }];
}

- (void)touchEndedGesture {
    void(^_touchBlock)(UIView *selfView) = objc_getAssociatedObject(self, kWDTouchEndedViewBlockKey);
    if (_touchBlock) {
        _touchBlock(self);
    }

}

@end