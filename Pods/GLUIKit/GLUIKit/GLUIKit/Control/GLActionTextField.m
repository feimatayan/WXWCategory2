//
//  GLActionTextField.m
//  WDPlugin_MyVDian
//
//  Created by xiaofengzheng on 12/23/15.
//  Copyright © 2015 Koudai. All rights reserved.
//

#import "GLActionTextField.h"
#import "GLTextField.h"

@implementation GLActionTextField


- (void)glSetup
{
    [super glSetup];
    if (!self.textField) {
        self.textField = [[GLTextField alloc] init];
        // UIColorFromRGB(0xd6d6d6)
        [self addSubview:self.textField];
    }
}


- (void)glCustomLayoutFrame:(CGRect)frame
{
    [super glCustomLayoutFrame:frame];
    
    self.textField.frame = self.bounds;
    

}



@end
