//
//  GLIMUtils.h
//  GLIMUI
//
//  Created by 六度 on 2017/3/2.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLIMSDK/GLIMSDK.h>


@interface NSArray (GLIMFoundation)

- (id)glim_objectAtIndex:(NSUInteger)index;

@end




typedef struct{
    
    /**
     *  @author Acorld, 15-01-15
     *
     *  @brief  从时间戳中取出天的数字
     */
    NSString* (*splitDateToDay)         (NSTimeInterval timeInterval);
    
    /**
     *  @author Acorld, 15-01-15
     *
     *  @brief  从时间戳中取出年月的数字，拼装成‘年.月’格式
     */
    NSString* (*splitDateToYearMonth)   (NSTimeInterval timeInterval);
    
    /**
     *  @brief  YYYY-MM-DD
     */
    NSString* (*splitDateToYearMonthDay)   (NSTimeInterval timeInterval);
    
    
    NSString* (*getMessageTimestamp)    (UInt64 messageTime, NSTimeInterval nowTimeInterval);
    NSString* (*getChatTimestamp)    (UInt64 messageTime, NSTimeInterval nowTimeInterval);

    
    NSNumber* (*convertToInsertTimeFromTime) (NSNumber *time);
    NSNumber* (*convertToTimeFromOtherTime) (NSNumber *time,NSUInteger outputLength);
    
    
    /**
     *  @author Acorld, 15-04-21
     *
     *  @brief  是否是有效的id
     */
    BOOL      (*isValidID)              (NSNumber *uid);
    
    UIFont*   (*transferToiOSFontSize)  (CGFloat size);
    
    BOOL      (*isLessThanIOS6)         (void);
    BOOL      (*isLessThanIOS7)         (void);
    BOOL      (*isLessThanIOS8)         (void);
    
    
    /**
     *  @author huangbiao, 16-03-15 10:03:26
     *
     *  毫秒数转为天数
     */
    NSUInteger (*dayFromMilliSeconds)(NSTimeInterval milliSeconds);
    
    /**
     *  @author huangbiao, 16-03-15 10:03:06
     *
     *  秒数转为天数
     */
    NSUInteger (*dayFromSeconds)(NSTimeInterval seconds);
    
    UIFont* (*adapterFontSize)(CGFloat size);
    
    UInt32 (*adapterPoint)(CGFloat point);
    
    CGRect (*adapterRectMake)(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
    
    CGRect (*adapterRectMakeWithFrame)(CGRect frame);
    
}GLIMUtils_;
extern GLIMUtils_ GLIMUtils;

#define GLIM_IS_IPHONE              (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)?YES:NO)

//@interface GLIMUtils : NSObject
//
//GLIMSINGLETON_HEADER(GLIMUtils);
//
//@end




