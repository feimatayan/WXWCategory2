//
// Created by reeceran on 14-9-15.
// Copyright (c) 2014 reeceran. All rights reserved.
//

#import "UIActionSheet+WDBlocksKit.h"
#import <objc/runtime.h>
#import "UIWindow+WDUIKit.h"

static const void *kWDActionSheetBlockKey = @"kWDActionSheetBlockKey";
static const void *kWDActionSheetBlockArrayKey = @"kWDActionSheetBlockArrayKey";

@implementation UIActionSheet (WDBlocksKit)

+ (UIActionSheet *)wd_showActionSheetViewWithTitle:(NSString *)title
                                 cancelButtonTitle:(NSString *)cancelButtonTitle
                            destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                 otherButtonTitles:(NSArray *)otherButtonTitles
                                           handler:(void (^)(UIActionSheet *actionSheet, NSInteger buttonIndex))block {
    if (!cancelButtonTitle.length && !otherButtonTitles.count) {
        cancelButtonTitle = @"取消";
    }

    UIActionSheet *actionSheet = [[[self class] alloc] initWithTitle:title
                                                            delegate:nil
                                                   cancelButtonTitle:cancelButtonTitle
                                              destructiveButtonTitle:destructiveButtonTitle
                                                   otherButtonTitles:nil];
    [actionSheet selfDelegate];

    // Set other buttons
    [otherButtonTitles enumerateObjectsUsingBlock:^(NSString *button, NSUInteger idx, BOOL *stop) {
        [actionSheet addButtonWithTitle:button];
    }];

    // Set `didDismissBlock`
    if (block) {
        objc_setAssociatedObject(actionSheet, kWDActionSheetBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }

    [actionSheet showInView:[UIWindow wd_keyWindow]];

    return actionSheet;
}

+ (id)wd_actionSheetWithTitle:(NSString *)title {
    return [[[self class] alloc] wd_initWithTitle:title];
}

-(void)selfDelegate{
    [self setDelegate:self];
}

- (id)wd_initWithTitle:(NSString *)title {
    return [self initWithTitle:title
                      delegate:self
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
}

- (NSInteger)wd_addButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
    NSAssert(title.length, @"A button without a title cannot be added to an action sheet.");
    NSInteger index = [self addButtonWithTitle:title];
    [self wd_setHandler:block forButtonAtIndex:index];
    return index;
}

- (NSInteger)wd_setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
    NSInteger index = [self wd_addButtonWithTitle:title handler:block];
    self.destructiveButtonIndex = index;
    return index;
}

- (NSInteger)wd_setCancelButtonWithTitle:(NSString *)title handler:(void (^)(void))block {
    NSInteger cancelButtonIndex = self.cancelButtonIndex;
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && !title.length)
        title = @"取消";
    
    if (title.length)
        cancelButtonIndex = [self addButtonWithTitle:title];

    [self wd_setHandler:block forButtonAtIndex:cancelButtonIndex];
    self.cancelButtonIndex = cancelButtonIndex;
    return cancelButtonIndex;
}

- (void)wd_setHandler:(void (^)(void))block forButtonAtIndex:(NSInteger)index {
    [self selfDelegate];
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, kWDActionSheetBlockArrayKey);
    if (!dictionary) {
        dictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
        objc_setAssociatedObject(self, kWDActionSheetBlockArrayKey, dictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (block) {
        dictionary[@(index)] = [block copy];
    } else {
        [dictionary removeObjectForKey:@(index)];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^base_block)(UIActionSheet *__actionSheet, NSInteger __buttonIndex);
    base_block = objc_getAssociatedObject(self, kWDActionSheetBlockKey);
    if (base_block) {
        base_block(actionSheet, buttonIndex);
    }
    
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, kWDActionSheetBlockArrayKey);
    void (^index_block)(void) = dictionary[@(buttonIndex)];
    if (index_block) {
        index_block();
    }
}

@end
