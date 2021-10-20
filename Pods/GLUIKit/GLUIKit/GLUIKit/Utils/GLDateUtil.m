//
//  GLDateUtil.m
//  BanJia
//
//  Created by xiaofengzheng on 14-9-18.
//  Copyright (c) 2014年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#define  minuteInterval  60
#define  secondsInterval  1
#define  hourInterval  (60*minuteInterval)
#define  dateInterval  (24*hourInterval)
#define  yearInterval  (365*dateInterval)

#import "GLDateUtil.h"

@implementation GLDateUtil

//- (NSString *)getDateString {
//	NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
//	dateFormater.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
//	[dateFormater setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
//    [dateFormater dateFromString:<#(NSString *)#>]
//    
//	NSString *dateString = [dateFormater stringFromDate:[NSDate date]];
//	[dateFormater release];
//	
//	return dateString;
//}
#pragma mark- banjia


+ (NSString *)getGroupName:(NSTimeInterval)timeInterval
{
    // 夜可以置 0
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
	dateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSString *datePrefix = [dateFormater stringFromDate:[NSDate date]];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *today = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",datePrefix,@"23:59:59.999"]];//@"2014-09-26 00:30:41"
    
    NSTimeInterval now = [today timeIntervalSince1970];
    NSTimeInterval gap = now - timeInterval;
    NSTimeInterval day = 60 * 60 * 24;
    NSInteger gapDay = gap/day;
    
    switch (gapDay) {
        case 0:
            return kGroupName_Today;
            break;
        case 1:
            return kGroupName_Yesterday;
            break;
        case 2:
            return kGroupName_TwoDayAgo;
            break;
        case 3:
            return kGroupName_ThreeDayAgo;
            break;
        case 4:
            return kGroupName_FourDayAgo;
            break;
        case 5:
            return kGroupName_FiveDayAgo;
            break;
        case 6:
            return kGroupName_SixDayAgo;
            break;
//        case 7:
//            return kGroupName_SixDayAgo;
//            break;
//        case 8:
//            return kGroupName_SevenDayAgo;
//            break;
            
        default:
            return kGroupName_SixDayAgo;
            break;
    }
}


////时间转时间戳
//+(NSString *)timeStrTotimeStamp:(NSInteger )timeStr{
//    //获取当前时间时间串
//    //与获得时间串进行对比
//    //根据时间差显示不同内容
//    //返回内容
//    int nowTime = [[NSDate date] timeIntervalSince1970];
//    //[[DSUtils timeStamp] intValue];
//    int gapTime = nowTime - timeStr;
//    
//    
//    
//    NSString *timeStamp = nil;
//    if (gapTime < 60) {
//        //一分钟内显示刚刚
//        timeStamp = [NSString stringWithFormat:@"刚刚"];
//    }else if(60<=gapTime && gapTime<60*60){
//        //一分钟以上且一个小时之内的，显示“多少分钟前”，例如“5分钟前”
//        timeStamp = [NSString stringWithFormat:@"%i分钟前",gapTime/60];
//    }else if (60*60<=gapTime && gapTime<60*60*24*3){
//        //1小时以上三天以内的显示“今天/昨天/前天+具体时间”
//        NSString *dayStr ;
//        int gapDay = gapTime/(60*60*24) ;
//        switch (gapDay) {
//            case 0:
//            {
//                //在24小时内,存在跨天的现象. 判断两个时间是否在同一天内.
//                NSDate *date1 = [NSDate date];
//                NSTimeInterval timeInterval = timeStr;
//                NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//                BOOL idSameDay = [GLPageTableItemView isSameDay:date1 date2:date2];
//                if (idSameDay == YES) {
//                    dayStr = [NSString stringWithFormat:@"今天"];
//                }else{
//                    dayStr = [NSString stringWithFormat:@"昨天"];
//                }
//            }
//                break;
//            case 1:
//                dayStr = [NSString stringWithFormat:@"昨天"];
//                break;
//            case 2:
//                dayStr = [NSString stringWithFormat:@"前天"];
//                break;
//            default:
//                break;
//        }
//        
//        NSLog(@"%@",dayStr);
//        //        timeStamp = [dayStr stringByAppendingString:[DSUtils smallTimewithTimeStr:timeStrs]];
//        //        timeStamp = [NSString stringWithFormat:@"%@%@",dayStr,[DSUtils smallTimewithTimeStr:timeStr]];
//    }else{
//        //前天以后的显示"日期+具体时间",如"2月11日 20:19"
//        //        timeStamp = [NSString stringWithString:[DSUtils speTimewithTimeStr:timeStr]];
//    }
//    NSLog(@"%@",timeStamp);
//    return [timeStamp copy];
//}
//




#pragma mark- koudai

// 显示开始抢购时间
+(NSString*)getDateStringValue:(NSTimeInterval)startTime curDate:(NSTimeInterval)curTime
{
    NSString* strV = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //当前日期
    NSDate *curDateTime = [NSDate dateWithTimeIntervalSince1970:(curTime)];
    NSDate *nowDate = [dateFormatter dateFromString: [dateFormatter stringFromDate:curDateTime]];
    //开始时间
    NSDate *startDateTime = [NSDate dateWithTimeIntervalSince1970:(startTime)];
    //开始日期
    NSDate *startDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:startDateTime]];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:nowDate toDate:startDate options:0];
    NSInteger days = [comps day];
    
    if (days == 0)
    {
        [dateFormatter setDateFormat:@"今天 HH:mm 开抢"];
    }
    else if (days == 1)
    {
        [dateFormatter setDateFormat:@"明天 HH:mm 开抢"];
    }
    else if (days == 2) {
        [dateFormatter setDateFormat:@"后天 HH:mm 开抢"];
    }
    else
    {
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm 开抢"];
    }
    
    strV = [dateFormatter stringFromDate:startDateTime];
    
    
    return strV;
}



//显示时间：08/15日 10:00
+(NSString*)getTimeString:(NSTimeInterval)ntime;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd日 HH:mm开抢"];
    NSDate *updateTimeDate = [NSDate dateWithTimeIntervalSince1970:(ntime)];
    NSString* strTime = [dateFormatter stringFromDate:updateTimeDate];
    return strTime;
}


// 显示剩余时间：08日 10:00
+(NSArray *)getRemainTimeString:(NSTimeInterval)remaintime perString:(NSString*)strPer
{
    int seconds = remaintime;
    seconds =  (seconds<0)?0:seconds;
    int nHour   = (seconds)/hourInterval;
    int nMinute = (seconds%hourInterval)/minuteInterval;
    int nSecond = (seconds%hourInterval)%minuteInterval;
    
    nHour = (nHour >= 1000)? 999:nHour;
    NSString *h = [NSString stringWithFormat:@"%0.2d",nHour];
    NSString *m = [NSString stringWithFormat:@"%0.2d",nMinute];
    NSString *s = [NSString stringWithFormat:@"%0.2d",nSecond];
    
//    NSString* strR= [NSString stringWithFormat:@"%@%0.2d时%0.2d分%0.2d秒",strPer,nHour,nMinute,nSecond];
    return [NSArray arrayWithObjects:h,m,s, nil];
}






#pragma mark- old
+ (NSInteger)dateCompareByDay:(CFGregorianDate)aDate1 Date2:(CFGregorianDate)aDate2
{
	if ( aDate1.year > aDate2.year )
		return 1;
	else if ( aDate1.year < aDate2.year )
		return -1;
	
	if ( aDate1.month > aDate2.month )
		return 1;
	else if ( aDate1.month < aDate2.month )
		return -1;
	
	if ( aDate1.day > aDate2.day )
		return 1;
	else if ( aDate1.day < aDate2.day )
		return -1;
	
	return 0;
}


+ (CFGregorianDate)stringToCFGregorianDate2:(NSString*)aStr
{
 	CFGregorianDate date;
	if (aStr.length == 0) {
        CFTimeZoneRef zf = CFTimeZoneCopySystem();
        date = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), zf);
        CFRelease(zf);
		return date;
	}
	NSMutableString* tempStr = [[NSMutableString alloc] initWithFormat:@"%@", aStr];
	NSMutableString* valueStr = [[NSMutableString alloc] initWithFormat:@"%@", aStr];
	NSRange range;
	
	range = [tempStr rangeOfString:@"-"];
	[valueStr setString:[tempStr substringWithRange:NSMakeRange(0, range.location)]];
	date.year = [valueStr intValue];
	[tempStr deleteCharactersInRange:NSMakeRange(0, range.location + 1)];
	
	range = [tempStr rangeOfString:@"-"];
	[valueStr setString:[tempStr substringWithRange:NSMakeRange(0, range.location)]];
	date.month = [valueStr intValue];
	[tempStr deleteCharactersInRange:NSMakeRange(0, range.location + 1)];
	
	[valueStr setString:tempStr];
	date.day = [valueStr intValue];
	
	date.hour = 0;
	date.minute = 0;
	date.second = 0;
	
	
	return date;
}

+ (CFGregorianDate)nextDay:(CFGregorianDate)date
{
	int daysCount = [GLDateUtil getDayCountOfaMonth:date];
	if ( date.day == daysCount ) {
		date = [GLDateUtil nextMonth:date];
		date.day = 1;
	}
	else
		date.day++;
	
	return date;
}




+ (NSString *)localDateByDay:(NSString *)dateStr hasTime:(BOOL)hasTime
{
    if(dateStr.length < 10 || (dateStr.length < 16 && hasTime)) return dateStr;
    CFTimeZoneRef zf = CFTimeZoneCopySystem();
    CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), zf);
    CFRelease(zf);
    CFGregorianDate refDate = [GLDateUtil stringToCFGregorianDate2:dateStr];
    
    CFGregorianDate yesterday = [GLDateUtil preDay:currentDate];
    //    CFGregorianDate beforeyesterday = [DateHelpMethods preDay:yesterday];
    CFGregorianDate tomorrow = [GLDateUtil nextDay:currentDate];
    CFGregorianDate afTomorrow = [GLDateUtil nextDay:tomorrow];
    
    NSString *result = @"";
    if ([GLDateUtil dateCompareByDay:refDate Date2:yesterday] == 0) {
        result = @"昨天";
        //NSLocalizedString(@"yesterday", @"昨天");
    }
    //    else if ([DateHelpMethods dateCompareByDay:refDate Date2:beforeyesterday] == 0) {
    //        result = NSLocalizedString(@"before of yesterday", @"前天");
    //    }
    else if ([GLDateUtil dateCompareByDay:refDate Date2:currentDate] == 0) {
        result = @"今天";
        //NSLocalizedString(@"today", @"今天");
    }
    else if ([GLDateUtil dateCompareByDay:refDate Date2:tomorrow] == 0) {
        result = @"明天";
        //NSLocalizedString(@"tomorrow", @"明天");
    }
    else if ([GLDateUtil dateCompareByDay:refDate Date2:afTomorrow] == 0) {
        result = @"后天";
        //NSLocalizedString(@"after of tomorrow", @"后天");
    }
    else if (currentDate.year == refDate.year) {
        //        result = [dateStr substringWithRange:NSMakeRange(5, 5)];
        result = [NSString stringWithFormat:@"%d-%d",refDate.month,refDate.day];
    }
    else {
        //        result = [dateStr substringToIndex:10];
        result = [NSString stringWithFormat:@"%d-%d-%d",(int)refDate.year,refDate.month,refDate.day];
        
    }
    
    if (hasTime) {
        //        return [NSString stringWithFormat:@"%@ %@", result, [dateStr substringWithRange:NSMakeRange(11, 5)]];
        NSString *timeStr = [NSString stringWithFormat:@"%ld:%@",(long)[[dateStr substringWithRange:NSMakeRange(11, 2)] integerValue],[dateStr substringWithRange:NSMakeRange(14, 2)]];
        return [NSString stringWithFormat:@"%@ %@", result,timeStr];
    }
    return result;
}


+ (CFGregorianDate)preDay:(CFGregorianDate)date
{
	if ( date.day == 1 ) {
		date = [GLDateUtil preMonth:date];
		date.day = [GLDateUtil getDayCountOfaMonth:date];
	}
	else
		date.day--;
	
	return date;
}

+ (CFGregorianDate)preMonth:(CFGregorianDate)date
{
	if ( date.month == 1 ){
		date.year--;
		date.month = 12;
	}
	else
		date.month--;
	
	if ( date.day > [GLDateUtil getDayCountOfaMonth:date] )
		date.day = [GLDateUtil getDayCountOfaMonth:date];
	
	return date;
}

+ (CFGregorianDate)nextMonth:(CFGregorianDate)date
{
	if ( date.month == 12 ){
		date.year++;
		date.month = 1;
	}
	else
		date.month++;
	
	if ( date.day > [GLDateUtil getDayCountOfaMonth:date] )
		date.day = [GLDateUtil getDayCountOfaMonth:date];
	
	return date;
}


+ (int)getDayCountOfaMonth:(CFGregorianDate)date
{
	switch ( date.month ) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
			
		case 2:
			if ( date.year%4 == 0 ) {
				if ( date.year % 100 != 0 )
					return 29;
				else {
					if ( date.year % 400 == 0 )
						return 29;
					else
						return 28;
				}
			}
			else
				return 28;
		case 4:
		case 6:
		case 9:
		case 11:
			return 30;
		default:
			return 31;
	}
}

@end
