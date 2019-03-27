//
//  LPHoursWorkListModel.m
//  BlueHired
//
//  Created by iMac on 2019/3/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHoursWorkListModel.h"

@implementation LPHoursWorkListModel

@end

@implementation LPHoursWorkListDataModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"overtimeList": @"LPHoursWorkListOverTimeModel",
             @"leaveList": @"LPHoursWorkListLeaveModel",
             @"shiftList": @"LPHoursWorkListShiftModel",
             };
}
@end

@implementation LPHoursWorkListOverTimeModel
@end

@implementation LPHoursWorkListLeaveModel
@end

@implementation LPHoursWorkListShiftModel
@end
