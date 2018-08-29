//
//  NSString+String.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "NSString+String.h"

@implementation NSString (String)

+ (NSString *)convertStringToTime:(NSString *)timeString{
    long long time=[timeString longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString*timeStr=[formatter stringFromDate:d];
    return timeStr;
}

@end
