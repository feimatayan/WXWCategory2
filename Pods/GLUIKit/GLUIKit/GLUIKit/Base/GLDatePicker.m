//
//  GLDatePicker.m
//  GLUIKit
//
//  Created by xiaofengzheng on 12/23/15.
//  Copyright © 2015 koudai. All rights reserved.
//

#import "GLDatePicker.h"

@implementation GLDatePicker

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 13.4, *)) {
            self.preferredDatePickerStyle = UIDatePickerStyleWheels;
            self.frame = frame;
        }
    }
    
    return self;
}

@end
