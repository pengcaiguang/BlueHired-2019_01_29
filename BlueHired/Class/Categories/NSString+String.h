//
//  NSString+String.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (String)
//毫秒时间戳转时间
+ (NSString *)convertStringToTime:(NSString *)timeString;
//获取当前系统时间的时间戳
+(NSInteger)getNowTimestamp;
//毫秒时间戳转时间
+ (NSString *)convertStringToYYYMMDD:(NSString *)timeString;
+ (NSString *)convertStringToYYYNMMYDDR:(NSString *)timeString;
//毫秒时间戳转几天前
+ (NSString *) compareCurrentTime:(NSString *)str;

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
@end
