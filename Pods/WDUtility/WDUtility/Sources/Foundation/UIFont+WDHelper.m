//
// Created by 莫昌星 on 2018/4/8.
//

#import "UIFont+WDHelper.h"


@implementation UIFont (WDHelper)

- (BOOL)wd_isEqualToFont:(UIFont *) font{
    return ([self.familyName isEqualToString:font.familyName]
            && self.pointSize == font.pointSize
            && self.ascender == font.ascender
            && self.descender == font.descender
            && self.capHeight == font.capHeight
            && self.xHeight == font.xHeight
            && self.lineHeight == font.lineHeight
            && self.leading == font.leading
            && [self.fontDescriptor isEqual:font.fontDescriptor]
    );
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[UIFont class]]){
        return [self wd_isEqualToFont:object];
    }
    return NO;
}

@end
