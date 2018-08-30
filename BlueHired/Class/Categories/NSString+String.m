//
//  NSString+String.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "NSString+String.h"

@implementation NSString (String)

//毫秒时间戳转时间
+ (NSString *)convertStringToTime:(NSString *)timeString{
    long long time=[timeString longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString*timeStr=[formatter stringFromDate:d];
    return timeStr;
}
//验证手机号
+ (BOOL)isMobilePhoneNumber:(NSString *)mobileNum {
    if (mobileNum.length != 11) {
        return NO;
    }
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|8[0-9]|9[89]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}
@end
