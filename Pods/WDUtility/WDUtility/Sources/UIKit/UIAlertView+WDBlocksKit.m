//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import "UIAlertView+WDBlocksKit.h"
#import <objc/runtime.h>

static const void *kWDAlertViewBlockKey = @"kWDAlertViewBlockKey";
static const void *kWDAlertViewBlockArrayKey = @"kWDAlertViewBlockArrayKey";

@implementation UIAlertView (WDBlocksKit)

+ (UIAlertView *)wd_showAlertViewWithTitle:(NSString *)title
                                   message:(NSString *)message
                         cancelButtonTitle:(NSString *)cancelButtonTitle
                         otherButtonTitles:(NSArray *)otherButtonTitles
                                   handler:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))block {
    if (!cancelButtonTitle.length && !otherButtonTitles.count) {
        cancelButtonTitle = @"取消";
    }

    UIAlertView *alertView = [[[self class] alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:cancelButtonTitle
                                               otherButtonTitles:nil];
    [alertView selfDelegate];
    // Set other buttons
    [otherButtonTitles enumerateObjectsUsingBlock:^(NSString *button, NSUInteger idx, BOOL *stop) {
        [alertView addButtonWithTitle:button];
    }];

    // Set `didDismissBlock`
    if (block) {
        objc_setAssociatedObject(alertView, kWDAlertViewBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }

    // Show alert view
    [alertView show];

    return alertView;
}

+ (id)wd_alertViewWithTitle:(NSString *)title {
    return [self wd_alertViewWithTitle:title message:nil];
}

+ (id)wd_alertViewWithTitle:(NSString *)title message:(NSString *)message {
    return [[[self class] alloc] wd_initWithTitle:title message:message];
}

- (void)selfDelegate {
    [self setDelegate:self];
}

- (id)wd_initWithTitle:(NSString *)title message:(NSString *)message {
    return [self initWithTitle:title
                       message:message
                      delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:nil];
}

- (NSInteger)wd_addButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
    NSAssert(title.length, @"A button without a title cannot be added to the alert view.");
    NSInteger index = [self addButtonWithTitle:title];
    [self wd_setHandler:block forButtonAtIndex:index];
    return index;
}

- (NSInteger)wd_setCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
    NSAssert(title.length, @"A button without a title cannot be added to the alert view.");
    NSInteger cancelButtonIndex = [self addButtonWithTitle:title];
    self.cancelButtonIndex = cancelButtonIndex;
    [self wd_setHandler:block forButtonAtIndex:cancelButtonIndex];
    return cancelButtonIndex;
}

- (void)wd_setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index {
    [self selfDelegate];
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, kWDAlertViewBlockArrayKey);
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
        objc_setAssociatedObject(self, kWDAlertViewBlockArrayKey, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (block) {
        dictionary[@(index)] = [block copy];
    } else {
        [dictionary removeObjectForKey:@(index)];
    }
}

- (void)wd_setCancelBlock:(void (^)(void))block {
    [self wd_setHandler:block forButtonAtIndex:0];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^base_block)(UIAlertView *__alertView, NSInteger __buttonIndex);
    base_block = objc_getAssociatedObject(self, kWDAlertViewBlockKey);
    if (base_block) {
        base_block(alertView, buttonIndex);
    }

    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, kWDAlertViewBlockArrayKey);
    void (^index_block)(void) = dictionary[@(buttonIndex)];
    if (index_block) {
        index_block();
    }
}

@end