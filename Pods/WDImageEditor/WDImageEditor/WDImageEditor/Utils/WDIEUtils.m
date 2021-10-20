//
//  WDIEUtils.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEUtils.h"

@implementation WDIEUtils

+ (UIColor *)wdie_colorFromRGB:(int)rgbValue {
	
	return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIImage *)wdie_copyImage:(UIImage *)image {
	CGImageRef newCgIm = CGImageCreateCopy(image.CGImage);
	UIImage *newImage = [UIImage imageWithCGImage:newCgIm scale:image.scale orientation:image.imageOrientation];
	CGImageRelease(newCgIm);
	return newImage;
}

+ (CGSize)wdie_sizeWithText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)csize
{
	CGSize size = CGSizeZero;
	if (!font) {
		return size;
	}
	
	NSDictionary *attributes = @{NSFontAttributeName : font};
	// NSString class method: boundingRectWithSize:options:attributes:context is
	// available only on ios7.0 sdk.
	CGRect rect = [text boundingRectWithSize:csize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
	size = rect.size;
	
	NSInteger labWidth,labHeight;
	labWidth = (NSInteger)size.width;
	labHeight = (NSInteger)size.height;
	
	if (size.width > labWidth) {
		labWidth = (NSInteger)size.width + 1;
	}
	if (size.height > labHeight) {
		labHeight = (NSInteger)size.height + 1;
	}
	
	CGSize lableNewSize = CGSizeMake(labWidth, labHeight);
	
	return lableNewSize;
}

@end
