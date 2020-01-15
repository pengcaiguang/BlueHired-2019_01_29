//
//  NSString+String.h
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (String)

/*!
 @brief 修正浮点型精度丢失
 @param str 传入接口取到的数据
 @return 修正精度后的数据
 */
+(NSString *)reviseString:(NSString *)str;

//毫秒时间戳转时间
+ (NSString *)convertStringToTime:(NSString *)timeString;
//毫秒时间戳转时间 yyyy-MM-dd HH:mm:ss
+ (NSString *)convertStringToTimeHHmm:(NSString *)timeString;
//获取当前系统时间的时间戳
+(NSInteger)getNowTimestamp;
//获取时间的时间戳
+(NSInteger)getNowTimestamp:(NSDate *)date;
//毫秒时间戳转时间

+ (NSString *)convertStringToYYYNMM:(NSString *)timeString;
+ (NSString *)convertStringToYYYMMDD:(NSString *)timeString;
+ (NSString *)convertStringToYYYNMMYDDR:(NSString *)timeString;
//毫秒时间戳转几天前
+ (NSString *) compareCurrentTime:(NSString *)str;
//NSDate加减
+(NSString*)dateAddFromString:(NSString*)string Day:(NSInteger) day;
//时间string 计算周几
+ (NSString*)weekdayStringFromDate:(NSString*)inputDateStr;
//传入 分  得到  xx时xx分
+(NSString *)getMMSSFromSS:(NSString *)totalTime;
//NSString转NSDate
+(NSDate*)dateFromString:(NSString*)string;
//验证手机号
+ (BOOL)isMobilePhoneNumber:(NSString *)mobileNum;
//身份证
+ (BOOL)isIdentityCard:(NSString *)IDCardNumber;
//银行卡
+ (BOOL)isBankCard:(NSString *)cardNumber;

- (NSString *)md5;

-(CGRect)getStringSize:(CGSize )size font:(UIFont *)font;

+ (NSString *)getDeviceName;

- (NSString *)changeEndTimeByKind:(NSInteger)changeKind withNum:(int)changeNum;

//时间处理
+ (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval;

@end
