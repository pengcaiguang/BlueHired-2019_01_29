//
//  DataTimeTool.h
//  BlueHired
//
//  Created by iMac on 2019/3/13.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTimeTool : NSObject
//获取年月日对象
+(NSDateComponents *)getDateComponents:(NSDate *)date;
//获得某年的周数
+(NSInteger)getWeek_AccordingToYear:(NSInteger)year;

/**
 *  获取某年某周的范围日期
 *
 *  @param year       年份
 *  @param weekofYear year里某个周
 *
 *  @return 时间范围字符串
 */
+(NSString*)getWeekRangeDate_Year:(NSInteger)year WeakOfYear:(NSInteger)weekofYear;
/**************************当前时间********************************/
+(NSDateComponents *)getCurrentDateComponents ;
+(NSInteger)getCurrentWeek;
+(NSInteger)getCurrentYear;

+(NSInteger)getCurrentQuarter;

+(NSInteger)getCurrentMonth;

+(NSInteger)getCurrentDay;
//NSString转NSDate
+(NSDate *)dateFromString:(NSString *)dateString DateFormat:(NSString *)DateFormat;


//NSDate转NSString
+(NSString *)stringFromDate:(NSDate *)date DateFormat:(NSString *)DateFormat;

//时间追加
+(NSString *)dateByAddingTimeInterval:(NSTimeInterval)TimeInterval DataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat;


//日期字符串格式化
+(NSString *)getDataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat ;


+(NSString *)getDataTime:(NSString *)dateStr DateFormat:(NSString *)DateFormat oldDateFormat:(NSString *)oldDateFormat;

+(int)getNumberOfCharactersInString:(NSString *)str c:(char)c ;

+(NSString *)getFormat:(NSString *)dateString ;
/**
 *  json日期转iOS时间
 *
 *  @param string /Date()
 *
 *  @return
 */
+(NSString *)interceptTimeStampFromStr:(NSString *)string DateFormat:(NSString *)DateFormat;

@end

NS_ASSUME_NONNULL_END
